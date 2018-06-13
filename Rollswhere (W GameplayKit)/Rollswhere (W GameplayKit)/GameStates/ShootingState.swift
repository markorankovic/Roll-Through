//
//  ShootingState.swift
//  Rollswhere (W GameplayKit)
//
//  Created by Marko on 01/06/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import GameplayKit

class ShootingState: GameState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == ReturnState.self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        stateMachine?.enter(ReturnState.self)
    }
        
    func shoot(ballBody: SKPhysicsBody) {
        ballBody.velocity.dx = scene.ball.power 
        scene.ball.power = 0
    }
    
    func setMoveableBlocksToCollide() {
        for block in scene.level.blocks {
            if let blockNode = block.component(ofType: ShapeComponent.self)?.shapeNode {
                if let ballNode = scene.ball.component(ofType: ShapeComponent.self)?.shapeNode {
                    blockNode.physicsBody!.categoryBitMask = ballNode.physicsBody!.collisionBitMask 
                } 
            }
        }
    }

    override func didEnter(from previousState: GKState?) {
        setMoveableBlocksToCollide()
        if let ballNode = scene.ball.component(ofType: ShapeComponent.self)?.shapeNode {
            shoot(ballBody: ballNode.physicsBody!)
        } 
        print("Entered shooting")
    }
    
} 
