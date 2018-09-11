//
//  GameState.swift
//  Rollswhere (W GameplayKit)
//
//  Created by Marko on 01/06/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import GameplayKit

class GameState: GKState {
        
    var ball: Ball? {
        return game.entities.first(where: { $0 is Ball }) as? Ball
    }
    
    func longPressGestureHandler(_ gestureRecognizer: UILongPressGestureRecognizer) { }  
    
    func swipeGestureHandler(_ gestureRecognizer: UISwipeGestureRecognizer) { } 
    
    func tapGestureHandler(_ gestureRecognizer: UITapGestureRecognizer) { }
    
    func rotateGestureHandler(_ gestureRecognizer: UIRotationGestureRecognizer) { }
    
    func panGestureHandler(_ gestureRecognizer: UIPanGestureRecognizer) { }
    
}


 
