//
//  TransitionState.swift
//  Rollswhere (W GameplayKit)
//
//  Created by Marko on 13/06/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import GameplayKit

class TransitionState: GameState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == ReturnState.self
    }
    
    override func didEnter(from previousState: GKState?) {
        print("Entered transition")
        if let view = game.scene?.view {
            game.moveToNextLevel(view: view) 
        }
    }
    
    #if os(iOS)
    
        override func tapGestureHandler(_ gestureRecognizer: UITapGestureRecognizer) {
            super.tapGestureHandler(gestureRecognizer)
        }
        
    #endif
    
}

