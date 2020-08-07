//
//  GameState.swift
//  Rollswhere (W GameplayKit)
//
//  Created by Marko on 01/06/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import GameplayKit

#if os(iOS)

class GameState: GKState, GestureHandler {
    
    var ball: Ball? {
        return game.entities.first(where: { $0 is Ball }) as? Ball
    }
    
    func longPressGestureHandler(_ gestureRecognizer: UILongPressGestureRecognizer) { }
    
    func swipeGestureHandler(_ gestureRecognizer: UISwipeGestureRecognizer) { }
    
    func tapGestureHandler(_ gestureRecognizer: UITapGestureRecognizer) {
        if gestureRecognizer.numberOfTouches == 2 {
            if let stateMachine = stateMachine {
                stateMachine.enter(PauseState.self)
            }
        }
    }
    
    func rotationGestureHandler(_ gestureRecognizer: UIRotationGestureRecognizer) { }
    
    func panGestureHandler(_ gestureRecognizer: UIPanGestureRecognizer) { }
    
}

#else

class GameState: GKState, GestureHandler {
    
    func scrollHandler(with event: NSEvent) {
        
    }
    
    var ball: Ball? {
        return game.ball
    }
    
    func longPressGestureHandler(gestureRecognizer: NSPressGestureRecognizer) { }
    
    func tapGestureHandler(gestureRecognizer: NSClickGestureRecognizer) {
    }
    
    func rotationGestureHandler(gestureRecognizer: NSRotationGestureRecognizer) { }
    
    func panGestureHandler(gestureRecognizer: NSPanGestureRecognizer) {  }

    func rKeyDown() {
        
    }
    
    func rKeyReleased() {
        
    }
    
    func escPressed() {
        if let stateMachine = stateMachine {
            stateMachine.enter(PauseState.self)
        }
    }
    
}

#endif


 
