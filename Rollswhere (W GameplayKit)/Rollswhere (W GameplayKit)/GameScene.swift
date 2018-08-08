//
//  GameScene.swift
//  Rollswhere (W GameplayKit)
//
//  Created by Marko on 01/06/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    func setCameraScale(xScale: CGFloat, yScale: CGFloat) {
        camera?.xScale = xScale
        camera?.yScale = yScale
    }
    
    override func didMove(to view: SKView) {
        
        let aspectRatio = view.frame.width / view.frame.height
        
        switch aspectRatio {
        case 16/9: setCameraScale(xScale: 1920 / view.frame.width, yScale: 1080 / view.frame.height)
        default: setCameraScale(xScale: 1920 / view.frame.width, yScale: 1920 / view.frame.width)
        } 
        
        game.stateMachine.enter(ReturnState.self)
    } 
    
}  

extension GameScene {
    
    func handleSwipe(_ gestureRecognizer: UISwipeGestureRecognizer) {
        if game.stateMachine.currentState is WaitingState {
            switch gestureRecognizer.direction {
                case .right: camera?.run(.moveBy(x: -600, y: 0, duration: 0.5))
                case .left: camera?.run(.moveBy(x: 600, y: 0, duration: 0.5))
                case .up: camera?.run(.moveBy(x: 0, y: -600, duration: 0.5))
                case .down: camera?.run(.moveBy(x: 0, y: 600, duration: 0.5)) 
                default: break
            } 
        }
    }
    
}

extension GameScene {
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let currentGameState = game.stateMachine.currentState as? GameState {
//            currentGameState.touchesBegan(touches, with: event)
//        }
//    }
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let currentGameState = game.stateMachine.currentState as? GameState {
//            currentGameState.touchesMoved(touches, with: event)
//        }
//    }
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let currentGameState = game.stateMachine.currentState as? GameState {
//            currentGameState.touchesEnded(touches, with: event)
//        }
//    }
} 

extension GameScene { 
    override func update(_ currentTime: TimeInterval) {
        game.loop(time: currentTime)
        game.stateMachine.currentState?.update(deltaTime: currentTime)
    }  
}
