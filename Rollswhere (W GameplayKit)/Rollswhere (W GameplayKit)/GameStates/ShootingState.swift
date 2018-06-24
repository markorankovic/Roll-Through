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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        stateMachine?.enter(ReturnState.self)
    }

    override func didEnter(from previousState: GKState?) {
        game.setDraggableEntitiesToCollide()
        ball?.component(ofType: PlayerControlComponent.self)?.shoot()  
        ball?.component(ofType: PlayerControlComponent.self)?.removePowerBar()  
        print("Entered shooting")   
    }

    override func update(deltaTime seconds: TimeInterval) {
        if game.ballInsideNode(nodeName: "exitPipe") {
            stateMachine?.enter(TransitionState.self)  
        }
    }

}
