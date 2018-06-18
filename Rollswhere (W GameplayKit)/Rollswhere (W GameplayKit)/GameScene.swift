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
     
    var entityManager: EnitityManager!
    var stateMachine: GKStateMachine!
    var draggingBlock: SKShapeNode?
    
    let ball = Ball(position: CGPoint(), radius: 50, fillColor: .brown)
    var level: Level = level1
        
    override func didMove(to view: SKView) { 
        backgroundColor = .blue
        entityManager = EnitityManager(scene: self)
     
        entityManager.add(entity: ball)
        
        loadLevel()
        
        stateMachine = GKStateMachine(states: [
            WaitingState(scene: self),
            ShootingState(scene: self),
            TransitionState(scene: self),
            ReturnState(scene: self),
            PauseState(scene: self),
        ])
        stateMachine.enter(ReturnState.self)
    }
    
}

extension GameScene {
    
    func loadLevel() {
        entityManager.add(entity: level.fixedPlatform)
        entityManager.add(entity: level.entryPipe)
        entityManager.add(entity: level.exitPipe)
        for block in level.blocks {
            entityManager.add(entity: block)
        }
        for obstacle in level.obstacles { 
            entityManager.add(entity: obstacle)
        }
    }
    
    func unloadLevel() {
        entityManager.remove(entity: level.fixedPlatform)
        entityManager.remove(entity: level.entryPipe)
        entityManager.remove(entity: level.exitPipe)
        for block in level.blocks {
            entityManager.remove(entity: block)
        }
        for obstacle in level.obstacles {
            entityManager.remove(entity: obstacle)
        }
    } 
    
    func moveToNextLevel() { 
        let index = levels.index(where: { $0 === level })
        if let levelNumber = index {
            unloadLevel()
            level = levelNumber + 1 < levels.count ? levels[levelNumber + 1] : level1
            loadLevel()
            stateMachine.enter(ReturnState.self)
        }
    }
    
    func transitionToNextLevel() {
        
    }

}

extension GameScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let currentGameState = stateMachine.currentState as? GameState {
            currentGameState.touchesBegan(touches, with: event)
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let currentGameState = stateMachine.currentState as? GameState {
            currentGameState.touchesMoved(touches, with: event)
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let currentGameState = stateMachine.currentState as? GameState {
            currentGameState.touchesEnded(touches, with: event)
        }
    }
}

extension GameScene {
    override func update(_ currentTime: TimeInterval) {
        stateMachine.currentState?.update(deltaTime: currentTime)
    }
}
