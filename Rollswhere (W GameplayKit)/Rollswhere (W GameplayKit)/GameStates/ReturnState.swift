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
        let ball = scene.ball 
        return ball.physicsBody!.isResting
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == WaitingState.self
    }
    
    func returnBall() {
        let ball = scene.ball
        let entryPipe = scene.level.entryPipe
        ball.physicsBody?.velocity = .init()
        ball.physicsBody?.angularVelocity = .init()
        ball.position = entryPipe.position
        print(ball.position) 
        ball.zRotation = 0
    }
    
    func setMoveableBlocksToNotCollide() {
        for block in scene.level.blocks {
            block.physicsBody!.categoryBitMask = 0
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

 
