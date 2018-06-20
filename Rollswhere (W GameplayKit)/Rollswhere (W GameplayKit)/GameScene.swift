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
     
    var stateMachine: GKStateMachine!
    var draggingBlock: SKShapeNode?
    
    let ball: SKShapeNode = {
        () in let shapeNode = SKShapeNode(circleOfRadius: 50)
        shapeNode.fillColor = .brown
        shapeNode.strokeColor = .black
        let powerBar = SKShapeNode(rectOf: .init(width: 0, height: 10))
        powerBar.position.y = 50 + 20
        powerBar.name = "power-bar"
        shapeNode.addChild(powerBar)
        powerBar.strokeColor = .red
        powerBar.lineWidth = 0
        powerBar.zPosition = 10
        let physicsBody = SKPhysicsBody(circleOfRadius: 50)
        shapeNode.physicsBody = physicsBody 
        return shapeNode 
    }()
    var power: CGFloat = 0
    var level: Level = level4  
       
    override func didMove(to view: SKView) { 
        backgroundColor = .blue
        addChild(ball)
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
        addChild(level.fixedPlatform)
        addChild(level.entryPipe)
        addChild(level.exitPipe)
        for block in level.blocks {
            addChild(block)
        }
        for obstacle in level.obstacles { 
            addChild(obstacle)
        }
    }
    
    func unloadLevel() {
        level.fixedPlatform.removeFromParent()
        level.entryPipe.removeFromParent()
        level.exitPipe.removeFromParent()
        for block in level.blocks {
            block.removeFromParent()
        }
        for obstacle in level.obstacles {
            obstacle.removeFromParent() 
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
