//
//  Game.swift
//  Rollswhere (Cross-Platform) Shared
//
//  Created by Marko on 14/12/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import GameplayKit

class Game {
    
    var entities: [GKEntity] = []
    let numberOfLevels = 11
    var level = 0
    var scene: GameScene?
    var physicsComponentSystem = GKComponentSystem(componentClass: PhysicsComponent.self)
    var stateMachine: GKStateMachine
    var ball: Ball? {
        return entities.first(where: { $0 is Ball }) as? Ball
    }
    
    var ballOutsideGame: Bool {
        if let ballNode = scene?.childNode(withName: "ball") {
            if let background = scene?.childNode(withName: "background") {
                print(background.frame.contains(ballNode.frame))
                return !(background.frame.contains(ballNode.frame))
            } 
        }
        return false
    }
    
    func transformPosition(position: CGPoint, relativeTo: CGPoint, newAngle: CGFloat) -> CGPoint {
        let dist = hypot(relativeTo.x - position.x, relativeTo.y - position.y)
        return CGPoint(x: relativeTo.x + dist * cos(newAngle), y: relativeTo.y + dist * sin(newAngle))
    }
    
    func ballInsideNode(nodeName: String) -> Bool {
        if let pipeNode = scene?.childNode(withName: nodeName) {
            if let ballNode = scene?.childNode(withName: "ball") {
                if let triggerNode = pipeNode.childNode(withName: "trigger") {
                    return triggerNode.intersects(ballNode)
                }
            }
            return false
        }
        return false
    }
    
    init() {
        stateMachine = GKStateMachine(states: [
            ReturnState(),
            WaitingState(),
            ShootingState(),
            TransitionState(),
            PauseState()
        ]) 
//        for body in scene!.children.map({ $0.physicsBody }) {
//            body?.usesPreciseCollisionDetection = true
//        }
    }
    
    func returnToMainMenu(view: SKView) {
        view.presentScene(MainMenuScene(fileNamed: "MainMenuScene.sks"))
    }
    
    func setUpGameEntities() {
        addBallEntity()
        addPipeEntities()
        addFixedEntities()
        addDraggableEntities()
        addFullPipeEntities()
        addTunnelEntities()
        setUpRope()
        setUpPortalSystem()
        setUpElectricGate()
        addSpeedBoosts()
        addGears()
    } 
    
    func addAllPhysicsComponents() {
        for entity in entities {
            physicsComponentSystem.addComponent(foundIn: entity)
        }
    }
    
    func addBallEntity() {
        if let ballNode = scene?.childNode(withName: "ball") as? SKSpriteNode {
            entities.append(Ball(node: ballNode))
        }
    }
    
    func addFullPipeEntities() {
        if let sceneNodes = scene?.children {
            let namedNodes = sceneNodes.filter({ $0.name != nil })
            let fullPipes = namedNodes.filter({ $0.name! == "fullPipe" })
            for fullPipe in fullPipes {
                let bounceObject = BounceObject(node: fullPipe)
                bounceObject.addComponent(FullPipeControlComponent())
                entities.append(bounceObject) 
            } 
        }
    }
    
    func addPipeEntities() {
        var pipes: [SKSpriteNode] = []
        if let children = scene?.children {
            for child in children {
                if let shapeNode = child as? SKSpriteNode {
                    if let name = shapeNode.name {
                        if name == "entryPipe" || name == "exitPipe" {
                            pipes.append(shapeNode)
                        }
                    } 
                }
            }
        } 
        for pipe in pipes {
            let body1 = SKPhysicsBody(edgeFrom: .init(x: -pipe.size.width / 2, y: -pipe.size.height / 2), to: .init(x: -pipe.size.width / 2, y: pipe.size.height / 2))
            let body2 = SKPhysicsBody(edgeFrom: .init(x: pipe.size.width / 2, y: -pipe.size.height / 2), to: .init(x: pipe.size.width / 2, y: pipe.size.height / 2))
            pipe.physicsBody = SKPhysicsBody(bodies: [body1, body2])
            pipe.physicsBody?.isDynamic = false
            entities.append(BounceObject(node: pipe))
        }
    } 
    
    func addFixedEntities() {
        if let fixedNodes = scene?.children.filter({ $0.name == "fixed" }) as? [SKSpriteNode] {
            for fixedNode in fixedNodes {   
                entities.append(BounceObject(node: fixedNode))
            }
        }
    }
    
    func addDraggableEntities() {
        if let blockNodes = scene?.children.filter({ $0.name == "block" }) as? [SKSpriteNode] {
            for blockNode in blockNodes {
                let block = BounceObject(node: blockNode)
                block.addComponent(PhysicsComponent(physicsBody: blockNode.physicsBody))
                let geometryComponent = GeometryComponent(node: blockNode)
                geometryComponent.originalPosition = blockNode.position
                geometryComponent.originalRotation = blockNode.zRotation 
                block.addComponent(geometryComponent)
                block.addComponent(DragComponent())
                block.addComponent(RotateComponent()) 
                entities.append(block)
            } 
        }
    }
    
    func setDraggableEntitiesToCollide() {
        print("Colliding") 
        let dragEntities = entities.filter({ $0.component(ofType: DragComponent.self) != nil })
        for entity in dragEntities {
            entity.component(ofType: PhysicsComponent.self)?.physicsBody?.categoryBitMask = ballCategory | ballContactCategory
            entity.component(ofType: PhysicsComponent.self)?.physicsBody?.contactTestBitMask = moveableContactCategory
        }
    }
    
    func setDraggableEntitiesToNotCollide(isReturning: Bool) {
        let dragEntities = entities.filter({ $0.component(ofType: DragComponent.self) != nil })
        for entity in dragEntities {
            if let disabled = entity.component(ofType: DragComponent.self)?.disabled {
                if disabled && !isReturning {
                    continue
                }
            }
            entity.component(ofType: PhysicsComponent.self)?.physicsBody?.categoryBitMask = 0
            entity.component(ofType: PhysicsComponent.self)?.physicsBody?.contactTestBitMask = moveableContactCategory
        }
    }
    
    func addTunnelEntities() {
        if let tunnelNodes = scene?.children.filter({ $0.name == "tunnel" }) {
            for tunnelNode in tunnelNodes {
                let tunnel = BounceObject(node: tunnelNode)
                entities.append(tunnel)
            } 
        }
    }
    
    func createRopeSegment(position: CGPoint, size: CGSize, fillColor: SKColor) -> SKSpriteNode {
        let newRopeSegment = SKSpriteNode(texture: .init(image: #imageLiteral(resourceName: "ropeSeg")), size: size)
        newRopeSegment.position = position
        newRopeSegment.zPosition = -1
        newRopeSegment.physicsBody = SKPhysicsBody(rectangleOf: size)
        newRopeSegment.physicsBody?.allowsRotation = false
        return newRopeSegment
    } 
    
    func attachRopeSegments(rope: SKNode) {
        for (i, seg) in rope.children.enumerated() {
            if i + 1 < rope.children.count {
                let link = SKPhysicsJointLimit.joint(withBodyA: seg.physicsBody!, bodyB: rope.children[i + 1].physicsBody!, anchorA: rope.convert(seg.position, to: rope.parent!), anchorB: rope.convert(rope.children[i + 1].position, to: rope.parent!))
                link.maxLength = rope.userData!["maxLength"] as! CGFloat
                scene?.physicsWorld.add(link)
            }
        } 
    }
    
    func setUpRope() {
        if let rope = scene?.childNode(withName: "rope") {
            attachRopeSegments(rope: rope)
        }
    }
    
    func setUpPortalSystem() {
        if let portalSystem = scene?.childNode(withName: "portalSystem") {
            guard let entryPortal = portalSystem.childNode(withName: "entryPortal") as? SKSpriteNode else {
                return
            }
            guard let exitPortal = portalSystem.childNode(withName: "exitPortal") as? SKSpriteNode else {
                return
            }
            let sourcePositions: [float2] = [
                float2(0, 0), float2(0.33, 0), float2(0.66, 0), float2(1, 0),
                float2(0, 0.33), float2(0.33, 0.33), float2(0.66, 0.33), float2(1, 0.33),
                float2(0, 0.66), float2(0.33, 0.66), float2(0.66, 0.66), float2(1, 0.66),
                float2(0, 1), float2(0.33, 1), float2(0.66, 1), float2(1, 1)
            ]
            let rightDest: [float2] = [
                float2(-0.1, 0.1), float2(0.23, 0.1), float2(0.56, 0.1), float2(0.9, 0.1),
                float2(0.1, 0.33), float2(0.43, 0.43), float2(0.76, 0.43), float2(1.1, 0.33),
                float2(0.1, 0.66), float2(0.43, 0.66), float2(0.76, 0.66), float2(1.1, 0.66),
                float2(0.1, 0.9), float2(0.43, 0.9), float2(0.76, 0.9), float2(1.1, 0.9)
            ]
            let leftDest: [float2] = [
                float2(0.1, -0.1), float2(0.43, -0.1), float2(0.66, -0.1), float2(1.1, -0.1),
                float2(-0.1, 0.33), float2(0.23, 0.23), float2(0.56, 0.23), float2(0.9, 0.33),
                float2(-0.1, 0.66), float2(0.23, 0.66), float2(0.56, 0.66), float2(0.9, 0.66),
                float2(-0.1, 1.1), float2(0.23, 1.1), float2(0.56, 1.1), float2(0.9, 1.1)
            ]
                        
            let rightWarpGrid = SKWarpGeometryGrid(columns: 3, rows: 3, sourcePositions: sourcePositions, destinationPositions: rightDest)
            let leftWarpGrid = SKWarpGeometryGrid(columns: 3, rows: 3, sourcePositions: sourcePositions, destinationPositions: leftDest)
            
            let warpGrids = [rightWarpGrid, leftWarpGrid]
            
            entryPortal.warpGeometry = SKWarpGeometryGrid(columns: 3, rows: 3)
            exitPortal.warpGeometry = SKWarpGeometryGrid(columns: 3, rows: 3)
            
            if let warpAction = SKAction.animate(withWarps: warpGrids, times: [0.4, 0.8]) {
                entryPortal.run(.repeatForever(warpAction))
                exitPortal.run(.repeatForever(warpAction))
            }

            let portalSystemEntity = PortalSystem(node: portalSystem)
            entities.append(portalSystemEntity)
        }
    }
    
    func setUpElectricGate() {
        if let electricGate = scene?.childNode(withName: "electricGate") {
            let electricGateEntity = ElectricGate(node: electricGate)
            entities.append(electricGateEntity)
        } 
    }
    
    func addSpeedBoosts() {
        let speedBoostNodes = scene!.children.filter{ $0.name == "speedBoost" }
        for speedBoostNode in speedBoostNodes {
            let speedBoostEntity = SpeedBoost(node: speedBoostNode)
            entities.append(speedBoostEntity)
        } 
    }
    
    func addGears() {
        let gearNodes = scene!.children.filter{ $0.name == "gear" }
        for gearNode in gearNodes {
            let gearNodeEntity = Gear(node: gearNode)
            entities.append(gearNodeEntity)
        } 
    }
    
    func loadLevel(view: SKView, levelNumber: Int) {
        level = levelNumber - 1
        moveToNextLevel(view: view)
    }
    
    func moveToNextLevel(view: SKView) {
        entities.removeAll()
        level += level == numberOfLevels ? 1 - numberOfLevels : 1
        print("New level: \(level)")
        scene = GameScene(fileNamed: "Level\(level).sks")
        //scene?.scaleMode = .aspectFit
        setUpGameEntities()
        addAllPhysicsComponents() 
        view.presentScene(scene!)
    }
    
    func loop(time: Double) {
        physicsComponentSystem.update(deltaTime: time)
    }
    
    func evaluateAbilityOfMoveableEntities(_ previousState: GKState?) {
        if let contactedBodies = ball?.component(ofType: PhysicsComponent.self)?.physicsBody?.allContactedBodies() {
            let moveableEntities = game.entities.filter({ $0.component(ofType: DragComponent.self) != nil })
            for moveableEntity in moveableEntities {
                if let moveableBody = moveableEntity.component(ofType: PhysicsComponent.self)?.physicsBody {
                    if contactedBodies.contains(moveableBody) && previousState is ShootingState {
                        moveableEntity.component(ofType: DragComponent.self)?.disable()
                        print("Block disabled")
                    } else {
                        moveableEntity.component(ofType: DragComponent.self)?.enable()
                    }
                }
            }
        }
    }
    
}


let rollbackContactCategory: UInt32 = 1 << 1
let ballCategory: UInt32 = 1 << 2
let fixedCategory: UInt32 = 1 << 3
let moveableCategory: UInt32 = 1 << 4
let moveableContactCategory: UInt32 = 1 << 5
let ballContactCategory: UInt32 = 1 << 6
let gateButtonContactCategory: UInt32 = 1 << 7

let game = Game()
