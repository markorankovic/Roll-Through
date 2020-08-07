//
//  ReturnState.swift
//  Rollswhere (W GameplayKit)
//
//  Created by Marko on 01/06/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import GameplayKit

extension SKPhysicsBody {
    
    var isResting: Bool {
        let v = hypot(velocity.dx, velocity.dy)
        return abs(v) < 1 && allContactedBodies().count >= 1 && !game.ballInsideNode(nodeName: "entryPipe")
    }  
    
}

class ReturnState: GameState {
        
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass != TransitionState.self
    }
    
    override func didEnter(from previousState: GKState?) {
        print("Entered return")
        
        if let block = game.scene?.childNode(withName: "block") {
            print(block.physicsBody!.affectedByGravity)
        }
        
        game.setDraggableEntitiesToNotCollide(isReturning: true)
        if previousState is ShootingState || previousState is ReturnState || previousState == nil {
            game.scene?.returnCamToCenter()
            ball?.component(ofType: PlayerControlComponent.self)?.returnToStart()
            let electricGates = game.entities.filter({ $0.component(ofType: ElectricGateControlComponent.self) != nil })
            for electricGate in electricGates {
                electricGate.component(ofType: ElectricGateControlComponent.self)?.closeGate()
            }
        }
    }
        
    override func update(deltaTime seconds: TimeInterval) {
        if let ballAtRest = ball?.component(ofType: PhysicsComponent.self)?.physicsBody?.isResting {
            if let ballBody = ball?.component(ofType: PhysicsComponent.self)?.physicsBody {
                print("ballBody collides with \(ballBody.allContactedBodies().first?.node?.name ?? "none")")
                if ballAtRest && !game.ballInsideNode(nodeName: "entryPipe") && ballBody.allContactedBodies().count > 0 {
                    stateMachine?.enter(WaitingState.self)
                }
            }
        }
    }
    
    #if os(iOS)
        override func tapGestureHandler(_ gestureRecognizer: UITapGestureRecognizer) {
            super.tapGestureHandler(gestureRecognizer)
            if game.ballOutsideGame && gestureRecognizer.numberOfTouches == 1 {
                stateMachine?.enter(ReturnState.self)
            }
        }
    #endif
    
}


