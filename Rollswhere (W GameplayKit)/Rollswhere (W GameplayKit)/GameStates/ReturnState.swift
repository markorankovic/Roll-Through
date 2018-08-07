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
        return abs(v) < 0.01 && allContactedBodies().count >= 1 && !game.ballInsideNode(nodeName: "entryPipe")
    }  
    
}

class ReturnState: GameState {
        
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == WaitingState.self
    }
    
    override func didEnter(from previousState: GKState?) {
        game.setDraggableEntitiesToNotCollide() 
        ball?.component(ofType: PlayerControlComponent.self)?.returnToStart()
        let electricGates = game.entities.filter({ $0.component(ofType: ElectricGateControlComponent.self) != nil })
        for electricGate in electricGates {
            electricGate.component(ofType: ElectricGateControlComponent.self)?.closeGate() 
        }
        print("Entered return")
    }
        
    override func update(deltaTime seconds: TimeInterval) {
        if let ballAtRest = ball?.component(ofType: PhysicsComponent.self)?.physicsBody?.isResting {
            if ballAtRest {
                stateMachine?.enter(WaitingState.self)
            }
        }
    }
    
}

 
