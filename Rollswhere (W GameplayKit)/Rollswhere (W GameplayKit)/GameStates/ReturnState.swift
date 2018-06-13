//
//  ReturnState.swift
//  Rollswhere (W GameplayKit)
//
//  Created by Marko on 01/06/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import GameplayKit

class ReturnState: GameState {
    
    var ballAtRest: Bool {
        if let ballNode = scene.ball.component(ofType: ShapeComponent.self)?.shapeNode {
            return ballNode.physicsBody!.isResting
        }
        return false
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == WaitingState.self
    }
    
    func returnBall() {
        if let ballNode = scene.ball.component(ofType: ShapeComponent.self)?.shapeNode {
            if let entryPipeNode = scene.level.entryPipe.component(ofType: ShapeComponent.self)?.shapeNode {
                ballNode.physicsBody?.velocity = .init()
                ballNode.physicsBody?.angularVelocity = .init()
                ballNode.position = entryPipeNode.position 
                ballNode.zRotation = 0 
            }
        }
    }
    
    func setMoveableBlocksToNotCollide() {
        for block in scene.level.blocks {
            if let blockNode = block.component(ofType: ShapeComponent.self)?.shapeNode {
                blockNode.physicsBody!.categoryBitMask = 0
            }
        } 
    }
    
    override func didEnter(from previousState: GKState?) {
        setMoveableBlocksToNotCollide()
        returnBall()
        print("Entered return")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if ballAtRest {
            stateMachine?.enter(WaitingState.self)
        }
    }
    
}

 
