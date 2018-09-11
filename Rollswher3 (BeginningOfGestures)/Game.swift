//
//  Game.swift
//  Rollswhere (ReturnTo-GKEntities)
//
//  Created by Marko on 20/06/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import GameplayKit

class Game {
    
    var entities: [GKEntity] = []
    var level = 0
    var scene: GameScene?
    var physicsComponentSystem = GKComponentSystem(componentClass: PhysicsComponent.self)
    var stateMachine: GKStateMachine  
    
    func transformPosition(position: CGPoint, relativeTo: CGPoint, newAngle: CGFloat) -> CGPoint {
        let dist = hypot(relativeTo.x - position.x, relativeTo.y - position.y)
        return CGPoint(x: relativeTo.x + dist * cos(newAngle), y: relativeTo.y + dist * sin(newAngle))
    }
    
    func ballInsideNode(nodeName: String) -> Bool {
        if let ballNode = scene?.childNode(withName: "ball") {
            if let pipeNode = scene?.childNode(withName: nodeName) {
                let transformedBallPosition = transformPosition(position: ballNode.position, relativeTo: pipeNode.position, newAngle: atan2(pipeNode.position.y - ballNode.position.y, pipeNode.position.x - ballNode.position.x) - pipeNode.zRotation)
                let transformedBallFrame = CGRect(x: transformedBallPosition.x - ballNode.frame.size.width/2, y: transformedBallPosition.y - ballNode.frame.size.height/2, width: ballNode.frame.size.width, height: ballNode.frame.size.height)
                //scene?.addChild(SKShapeNode(rect: transformedBallFrame))
                let temp = pipeNode.zRotation
                pipeNode.zRotation = 0
                let transformedPipeFrame = pipeNode.frame
                //scene?.addChild(SKShapeNode(rect: transformedPipeFrame)) 
                pipeNode.zRotation = temp
              
                return transformedPipeFrame.contains(transformedBallFrame)
            }
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
        moveToNextLevel()
//        for body in scene!.children.map({ $0.physicsBody }) {
//            body?.usesPreciseCollisionDetection = true
//        }
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
            let body = SKPhysicsBody(bodies: [body1, body2])
            body.affectedByGravity = false
            body.isDynamic = false 
            body.allowsRotation = true 
            pipe.physicsBody = body  
            body.pinned = true
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
                block.addComponent(GeometryComponent(node: blockNode))
                block.addComponent(DragComponent())
                block.addComponent(RotateComponent()) 
                entities.append(block)
            } 
        }
    }
    
    func setDraggableEntitiesToCollide() {
        let dragEntities = entities.filter({ $0.component(ofType: DragComponent.self) != nil })
        if let ballBitMask = scene?.childNode(withName: "ball")?.physicsBody?.collisionBitMask {
            for entity in dragEntities {
                entity.component(ofType: PhysicsComponent.self)?.physicsBody?.categoryBitMask = ballBitMask
            }  
        }
    }  
    
    func setDraggableEntitiesToNotCollide() {
        let dragEntities = entities.filter({ $0.component(ofType: DragComponent.self) != nil })
        for entity in dragEntities {
            entity.component(ofType: PhysicsComponent.self)?.physicsBody?.categoryBitMask = 0
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
    
    func createRopeSegment(position: CGPoint, size: CGSize, fillColor: UIColor) -> SKSpriteNode {
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
//            guard rope.children.count == 2 else {
//                return
//            }
//            let firstHook = rope.children.first!
//            let lastHook = rope.children.last!
//            let dist = firstHook.position.hypot2(point: lastHook.position)
//            let segLength = firstHook.frame.width
//            for offsetX in stride(from: segLength, to: dist - segLength, by: segLength) {
//                rope.insertChild(createRopeSegment(position: CGPoint(x: firstHook.position.x + offsetX, y: firstHook.position.y), size: CGSize(width: segLength, height: segLength), fillColor: .brown), at: 1)
//            }
            attachRopeSegments(rope: rope)
        }
    }
    
    func setUpPortalSystem() {
        if let portalSystem = scene?.childNode(withName: "portalSystem") {
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
    
    func moveToNextLevel() {
        entities.removeAll()
        level += level == 4 ? -3 : 1
        scene = GameScene(fileNamed: "BaseLevel.sks")
        scene?.view?.presentScene(scene!) 
        setUpGameEntities()
        addAllPhysicsComponents()  
    }  
    
    func loop(time: Double) {
        physicsComponentSystem.update(deltaTime: time) 
    } 
    
}

let game = Game()  
