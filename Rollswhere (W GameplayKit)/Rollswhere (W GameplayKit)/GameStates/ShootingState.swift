//
//  ShootingState.swift
//  Rollswhere (W GameplayKit)
//
//  Created by Marko on 01/06/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import GameplayKit

class ShootingState: GameState {
    
    var ballInsideExitPipe: Bool {
        let ballNode = scene.ball
        let exitPipeNode = scene.level.exitPipe
        let transformedPos = CGPoint(x: ballNode.position.x - exitPipeNode.position.x, y: ballNode.position.y - exitPipeNode.position.y).applying(CGAffineTransform(rotationAngle: -exitPipeNode.zRotation))
        let ballRadius = ballNode.frame.width / 2
        let ballTransformedPos = CGPoint(x: transformedPos.x + exitPipeNode.position.x - ballRadius, y: transformedPos.y + exitPipeNode.position.y - ballRadius)
        let ballRect = CGRect(origin: ballTransformedPos, size: ballNode.frame.size)
        let pipeRect = exitPipeNode.frame
        return pipeRect.contains(ballRect)
    } 
    
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == ReturnState.self || stateClass == TransitionState.self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        stateMachine?.enter(ReturnState.self)
    }
        
    func shoot(ballBody: SKPhysicsBody) {
        ballBody.velocity.dx = scene.power
        scene.power = 0
    }
    
    func setMoveableBlocksToCollide() {
        for block in scene.level.blocks {
            if let blockBody = block.physicsBody {
                if let ballBody = scene.ball.physicsBody {
                    blockBody.categoryBitMask = ballBody.collisionBitMask
                } 
            }
        }
    }

    override func didEnter(from previousState: GKState?) {
        setMoveableBlocksToCollide()
        if let ballBody = scene.ball.physicsBody {
            shoot(ballBody: ballBody)
        }
        print("Entered shooting")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if ballInsideExitPipe {
            stateMachine?.enter(TransitionState.self)   
        }
    }
    
} 
