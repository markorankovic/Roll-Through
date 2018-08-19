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
        return stateClass == ReturnState.self || stateClass == TransitionState.self
    }

    override func tapGestureHandler(_ gestureRecognizer: UITapGestureRecognizer) {
        stateMachine?.enter(ReturnState.self)
    } 
    
    override func didEnter(from previousState: GKState?) {
        game.setDraggableEntitiesToCollide()
        ball?.component(ofType: PlayerControlComponent.self)?.shoot()  
        ball?.component(ofType: PlayerControlComponent.self)?.removePowerBar()
        print("Entered shooting")   
    }
    
    override func panGestureHandler(_ gestureRecognizer: UIPanGestureRecognizer) {
        if game.debugMode {
            if gestureRecognizer.state == .began {
                ball?.component(ofType: PhysicsComponent.self)?.physicsBody?.affectedByGravity = false
            } else if gestureRecognizer.state == .ended {
                ball?.component(ofType: PhysicsComponent.self)?.physicsBody?.affectedByGravity = true
            }
            for block in game.entities.filter({ $0.component(ofType: DragComponent.self) != nil }) {
                block.component(ofType: DragComponent.self)?.panGestureHandler(gestureRecognizer)
            } 
        }
    }

    override func update(deltaTime seconds: TimeInterval) {
        if let ballNode = ball?.component(ofType: GeometryComponent.self)?.node {
            game.scene?.tryMoveCamTo(node: ballNode)
        }
        
        if game.ballInsideNode(nodeName: "exitPipe") && !game.debugMode {
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

}
