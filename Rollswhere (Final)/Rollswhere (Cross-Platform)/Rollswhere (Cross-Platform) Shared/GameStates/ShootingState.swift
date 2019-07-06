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
        return stateClass == WaitingState.self || stateClass == TransitionState.self || stateClass == PauseState.self || stateClass == ReturnState.self
    }
    
    override func didEnter(from previousState: GKState?) {
        
//        if let contactedBodies = ball?.component(ofType: PhysicsComponent.self)?.physicsBody?.allContactedBodies() {
//            let moveableEntities = game.entities.filter({ $0.component(ofType: DragComponent.self) != nil })
//            for moveableEntity in moveableEntities {
//                if let moveableBody = moveableEntity.component(ofType: PhysicsComponent.self)?.physicsBody {
//                    if contactedBodies.contains(moveableBody) {
//                        moveableEntity.component(ofType: DragComponent.self)?.enable()
//                    }
//                }
//            }
//        }
        
        game.setDraggableEntitiesToCollide()
        if previousState is WaitingState {
            ball?.component(ofType: PlayerControlComponent.self)?.shoot()
            ball?.component(ofType: PlayerControlComponent.self)?.removePowerBar()
        } 
        print("Entered shooting")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
        //ball?.component(ofType: PlayerControlComponent.self)?.reactToBounce()
        
        if let ballNode = ball?.component(ofType: GeometryComponent.self)?.node {
            if let ballBody = ballNode.physicsBody {
                if ballBody.isResting {
                    print("Rested")
                    stateMachine?.enter(WaitingState.self)
                }
            }
            game.scene?.tryMoveCamTo(node: ballNode)
        }
        
        if game.ballInsideNode(nodeName: "exitPipe") {
            stateMachine?.enter(TransitionState.self)
        }
        
        let fullPipes = game.entities.filter({ $0.component(ofType: FullPipeControlComponent.self) != nil })
        let tunnels = game.entities.filter({ $0.component(ofType: SpeedBoostComponent.self) != nil })
        let portalSystems = game.entities.filter({ $0.component(ofType: PortalSystemControlComponent.self) != nil })
        let electricGates = game.entities.filter({ $0.component(ofType: ElectricGateControlComponent.self) != nil })
        if let ballNode = ball?.component(ofType: GeometryComponent.self)?.node {
            for fullPipe in fullPipes {
                fullPipe.component(ofType: FullPipeControlComponent.self)?.reactToObject(object: ballNode)
            }
            for tunnel in tunnels {
                tunnel.component(ofType: SpeedBoostComponent.self)?.reactToNode(node: ballNode)
            }
            for portalSystem in portalSystems {
                portalSystem.component(ofType: PortalSystemControlComponent.self)?.reactToObject(object: ballNode)
            } 
            for electricGate in electricGates {
                electricGate.component(ofType: ElectricGateControlComponent.self)?.reactToNode(node: ballNode)
            }
        }
    }
    
    #if canImport(UIKit) // Instead of considering presence of iOS, UIKit's importability could work
    
    #elseif canImport(AppKit)
    
    #endif
    
    #if os(iOS)
    
        override func tapGestureHandler(_ gestureRecognizer: UITapGestureRecognizer) {
            super.tapGestureHandler(gestureRecognizer)
            if gestureRecognizer.numberOfTouches == 1 {
                stateMachine?.enter(ReturnState.self)
            }
        }
    
    #else
    
        override func tapGestureHandler(gestureRecognizer: NSClickGestureRecognizer) {
            stateMachine?.enter(ReturnState.self)
        }
        
    #endif
    
}

