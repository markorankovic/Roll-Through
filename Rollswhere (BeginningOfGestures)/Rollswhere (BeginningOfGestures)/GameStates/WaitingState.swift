//
//  WaitingState.swift
//  Rollswhere (W GameplayKit)
//
//  Created by Marko on 01/06/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import GameplayKit

class WaitingState: GameState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return PauseState.self == stateClass || ShootingState.self == stateClass
    }
    
    override func longPressGestureHandler(_ gestureRecognizer: UILongPressGestureRecognizer) {
        game.scene?.returnCamToCenter()
    } 
    
    override func swipeGestureHandler(_ gestureRecognizer: UISwipeGestureRecognizer) {
        game.scene?.panCamera(gestureRecognizer)
    }
    
    override func panGestureHandler(_ gestureRecognizer: UIPanGestureRecognizer) {
        ball?.component(ofType: PlayerControlComponent.self)?.panGestureHandler(gestureRecognizer)
        for block in game.entities.filter({ $0.component(ofType: DragComponent.self) != nil }) {
            block.component(ofType: DragComponent.self)?.panGestureHandler(gestureRecognizer)
        }
    }
    
    override func rotationGestureHandler(_ gestureRecognizer: UIRotationGestureRecognizer) {
        for block in game.entities.filter({ $0.component(ofType: DragComponent.self) != nil }) {
            block.component(ofType: RotateComponent.self)?.rotateGestureHandler(gestureRecognizer)
        } 
    }
    
    override func didEnter(from previousState: GKState?) {
        ball?.component(ofType: PlayerControlComponent.self)?.resetPowerBar()  
        ball?.component(ofType: PlayerControlComponent.self)?.addPowerBar()
        print("Entered waiting")
    }
    
}


