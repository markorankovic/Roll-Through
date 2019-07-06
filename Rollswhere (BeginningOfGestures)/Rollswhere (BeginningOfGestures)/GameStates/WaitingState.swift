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
    
    override func tapGestureHandler(_ gestureRecognizer: UITapGestureRecognizer) {
        super.tapGestureHandler(gestureRecognizer)
        if game.ballOutsideGame && gestureRecognizer.numberOfTouches == 1 {
            stateMachine?.enter(ReturnState.self)
        }
    }
    
    override func panGestureHandler(_ gestureRecognizer: UIPanGestureRecognizer) {
        ball?.component(ofType: PlayerControlComponent.self)?.panGestureHandler(gestureRecognizer)
        for entity in game.entities {
            if let dragComponent = entity.component(ofType: DragComponent.self) {
                dragComponent.panGestureHandler(gestureRecognizer)
                game.scene?.evaluateRollback(entity: entity, gestureRecognizer: gestureRecognizer)
            } 
        }
    }
    
    override func rotationGestureHandler(_ gestureRecognizer: UIRotationGestureRecognizer) {
        for block in game.entities.filter({ $0.component(ofType: RotateComponent.self) != nil }) {
            block.component(ofType: RotateComponent.self)?.rotateGestureHandler(gestureRecognizer)
        }
    }
    
    override func didEnter(from previousState: GKState?) {
        print("Entered waiting")
        ball?.component(ofType: PlayerControlComponent.self)?.resetBall()
        ball?.component(ofType: PlayerControlComponent.self)?.stopMovement()
    }
    
}


