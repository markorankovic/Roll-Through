//
//  PauseState.swift
//  Rollswhere (W GameplayKit)
//
//  Created by Marko on 01/06/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import GameplayKit

class PauseState: GameState {
    
    var previousState: GKState?
    
    override func didEnter(from previousState: GKState?) {
        print("Entered pause")
        self.previousState = previousState
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if scene.nodes(at: touches.first!.location(in: scene)).first?.name == "togglePauseButton" {
            if let state = previousState {
                stateMachine?.enter(type(of: state))
            }
        }
    }
    
}

 
