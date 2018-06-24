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
    
    override func didMove(to view: SKView) {
        game.stateMachine.enter(ReturnState.self)  
    } 
    
}  

extension GameScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let currentGameState = game.stateMachine.currentState as? GameState {
            currentGameState.touchesBegan(touches, with: event)
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let currentGameState = game.stateMachine.currentState as? GameState {
            currentGameState.touchesMoved(touches, with: event)
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let currentGameState = game.stateMachine.currentState as? GameState {
            currentGameState.touchesEnded(touches, with: event)
        }
    }
}

extension GameScene { 
    override func update(_ currentTime: TimeInterval) {
        game.loop(time: currentTime)
        game.stateMachine.currentState?.update(deltaTime: currentTime)
    }  
}
