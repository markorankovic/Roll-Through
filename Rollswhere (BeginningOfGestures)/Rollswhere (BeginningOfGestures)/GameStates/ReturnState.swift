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
        if game.debugMode {
            return stateClass == ShootingState.self
        }
        return stateClass == WaitingState.self
    }
    
    override func didEnter(from previousState: GKState?) {
        if game.debugMode {
            ball?.component(ofType: PhysicsComponent.self)?.physicsBody?.affectedByGravity = true
            if let entryPipe = game.scene?.childNode(withName: "entryPipe") {
                ball?.component(ofType: GeometryComponent.self)?.node?.position = entryPipe.position
                ball?.component(ofType: PhysicsComponent.self)?.physicsBody?.velocity = CGVector()
            }       
        }
        game.scene?.returnCamToCenter() 
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
                if game.debugMode {
                    stateMachine?.enter(ShootingState.self)
                } else {
                    stateMachine?.enter(WaitingState.self)
                }
            }
        }
    }
    
}

 
