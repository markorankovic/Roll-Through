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
    
    func ballInsideNode(nodeName: String) -> Bool {
        let ballNode = scene?.childNode(withName: "ball")
        let pipeNode = scene?.childNode(withName: nodeName)
        if let ballNode = ballNode as? SKSpriteNode {
            if let pipeNode = pipeNode as? SKSpriteNode {
                let transformedPos = CGPoint(x: ballNode.position.x - pipeNode.position.x, y: ballNode.position.y - pipeNode.position.y).applying(CGAffineTransform(rotationAngle: -pipeNode.zRotation))
                let ballRadius = ballNode.frame.size.width / 2   
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
        if let ballNode = scene?.childNode(withName: "ball") as? SKSpriteNode {
            entities.append(Ball(spriteNode: ballNode))
        }
    }
    
    func addPipeEntities() {
        var pipes: [SKSpriteNode] = []
        if let children = scene?.children {
            for child in children {
                if let shapeNode = child as? SKSpriteNode {
                    if let name = shapeNode.name {
                        if name.contains("Pipe") {
                            pipes.append(shapeNode)
                        }
                    }
                }
            }
        } 
        for pipe in pipes {
            let body1 = SKPhysicsBody(edgeFrom: .init(x: -pipe.frame.size.width / 2, y: -pipe.frame.size.height / 2), to: .init(x: -pipe.frame.size.width / 2, y: pipe.frame.size.height / 2))
            let body2 = SKPhysicsBody(edgeFrom: .init(x: pipe.frame.size.width / 2, y: -pipe.frame.size.height / 2), to: .init(x: pipe.frame.size.width / 2, y: pipe.frame.size.height / 2))
            let body = SKPhysicsBody(bodies: [body1, body2])
            pipe.physicsBody = body  
            body.pinned = true
            entities.append(BounceObject(spriteNode: pipe))
        }
    }
    
    func addFixedEntities() {
        if let fixedNodes = scene?.children.filter({ $0.name == "fixed" }) as? [SKSpriteNode] {
            for fixedNode in fixedNodes {   
                entities.append(BounceObject(spriteNode: fixedNode))
            }
        }
    }
    
    func addDraggableEntities() {
        if let blockNodes = scene?.children.filter({ $0.name == "block" }) as? [SKSpriteNode] {
            for blockNode in blockNodes {
                let block = BounceObject(spriteNode: blockNode)
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
        level += level == 1 ? 0 : 1
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
