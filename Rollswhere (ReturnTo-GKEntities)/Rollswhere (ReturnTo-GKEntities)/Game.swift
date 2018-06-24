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
    var level = 4  
    var scene: GameScene?
    var physicsComponentSystem = GKComponentSystem(componentClass: PhysicsComponent.self)
    var stateMachine: GKStateMachine  
    
    func ballInsideNode(nodeName: String) -> Bool {
        let ballNode = scene?.childNode(withName: "ball")
        let pipeNode = scene?.childNode(withName: nodeName)
        if let ballNode = ballNode as? SKShapeNode {
            if let pipeNode = pipeNode as? SKShapeNode {
                let transformedPos = CGPoint(x: ballNode.position.x - pipeNode.position.x, y: ballNode.position.y - pipeNode.position.y).applying(CGAffineTransform(rotationAngle: -pipeNode.zRotation))
                let ballRadius = ((ballNode.path?.boundingBox.size.width)! * ballNode.xScale) / 2
                let ballTransformedPos = CGPoint(x: transformedPos.x + pipeNode.position.x - ballRadius, y: transformedPos.y + pipeNode.position.y - ballRadius)
                let ballRect = CGRect(origin: ballTransformedPos, size: CGSize(width: ballRadius * 2, height: ballRadius * 2))
                let pipeRect = pipeNode.frame
                return pipeRect.contains(ballRect)
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
    }
    
    func setUpGameEntities() {
        addBallEntity()
        addPipeEntities()
        addFixedEntities()
        addDraggableEntities() 
    }
    
    func addAllPhysicsComponents() {
        for entity in entities {
            physicsComponentSystem.addComponent(foundIn: entity)
        }
    }
    
    func addBallEntity() {
        if let ballNode = scene?.childNode(withName: "ball") as? SKShapeNode {
            let node = SKShapeNode(ellipseOf: ballNode.frame.size) 
            node.position = ballNode.position
            node.fillColor = ballNode.fillColor
            node.strokeColor = ballNode.strokeColor
            node.lineWidth = 0.5
            node.zPosition = ballNode.zPosition
            node.name = ballNode.name
            ballNode.removeFromParent()
            scene?.addChild(node)
            entities.append(Ball(shapeNode: node))
        }
    }
    
    func addPipeEntities() {
        var pipes: [SKShapeNode] = []
        if let children = scene?.children {
            for child in children {
                if let shapeNode = child as? SKShapeNode {
                    if let name = shapeNode.name {
                        if name.contains("Pipe") {
                            pipes.append(shapeNode)
                        }
                    }
                }
            }
        } 
        for pipe in pipes {
            let node = SKShapeNode(rectOf: CGSize(width: (pipe.path?.boundingBox.width)! * pipe.xScale, height: (pipe.path?.boundingBox.height)! * pipe.yScale))
            node.position = pipe.position
            node.fillColor = pipe.fillColor
            node.strokeColor = pipe.strokeColor
            node.lineWidth = 0.5
            node.zPosition = pipe.zPosition
            node.name = pipe.name
            pipe.removeFromParent()
            scene?.addChild(node)
            let body1 = SKPhysicsBody(edgeFrom: .init(x: -node.frame.size.width / 2, y: -node.frame.size.height / 2), to: .init(x: -node.frame.size.width / 2, y: node.frame.size.height / 2))
            let body2 = SKPhysicsBody(edgeFrom: .init(x: node.frame.size.width / 2, y: -node.frame.size.height / 2), to: .init(x: node.frame.size.width / 2, y: node.frame.size.height / 2))
            node.zRotation = pipe.zRotation  
            let body = SKPhysicsBody(bodies: [body1, body2])
            body.pinned = true
            entities.append(BounceObject(shapeNode: node, physicsBody: body))
        }
    }
    
    func addFixedEntities() {
        if let fixedNodes = scene?.children.filter({ $0.name == "fixed" }) as? [SKShapeNode] {
            for fixedNode in fixedNodes {   
                let node = SKShapeNode(rectOf: CGSize(width: (fixedNode.path?.boundingBox.width)! * fixedNode.xScale, height: (fixedNode.path?.boundingBox.height)! * fixedNode.yScale))
                node.position = fixedNode.position  
                node.fillColor = fixedNode.fillColor  
                node.strokeColor = fixedNode.strokeColor
                node.lineWidth = 0.5
                node.zPosition = fixedNode.zPosition
                node.name = fixedNode.name
                node.zRotation = fixedNode.zRotation  
                fixedNode.removeFromParent()
                scene?.addChild(node)
                entities.append(BounceObject(shapeNode: node, physicsBody: SKPhysicsBody(edgeLoopFrom: CGRect(origin: CGPoint(x: -node.path!.boundingBox.size.width/2, y: -node.path!.boundingBox.size.height/2), size: node.path!.boundingBox.size))))
            }   
        }
    }
    
    func addDraggableEntities() {
        if let blockNodes = scene?.children.filter({ $0.name == "block" }) as? [SKShapeNode] {
            for blockNode in blockNodes {
                let node = SKShapeNode(rectOf: CGSize(width: (blockNode.path?.boundingBox.width)! * blockNode.xScale, height: (blockNode.path?.boundingBox.height)! * blockNode.yScale))
                node.position = blockNode.position
                node.fillColor = blockNode.fillColor
                node.strokeColor = blockNode.strokeColor
                node.lineWidth = 0.5
                node.zPosition = blockNode.zPosition
                node.name = blockNode.name
                node.zRotation = blockNode.zRotation   
                blockNode.removeFromParent()
                scene?.addChild(node)
                let block = BounceObject(shapeNode: node, physicsBody: SKPhysicsBody(edgeLoopFrom: CGRect(origin: CGPoint(x: -node.path!.boundingBox.size.width/2, y: -node.path!.boundingBox.size.height/2), size: node.path!.boundingBox.size)))
                block.addComponent(DragComponent())
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
    
    func moveToNextLevel() {
        entities.removeAll()
        level += level > 4 ? -4 : 1
        let s = GameScene(fileNamed: "Level\(level).sks")    
        scene?.view?.presentScene(s)
        scene = s 
        setUpGameEntities()
        addAllPhysicsComponents()
    }  
    
    func loop(time: Double) {
        physicsComponentSystem.update(deltaTime: time) 
    }
    
}

let game = Game()  
