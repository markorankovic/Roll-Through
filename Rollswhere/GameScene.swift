//
//  GameScene.swift
//  Rollswhere
//
//  Created by Marko on 08/04/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var power: CGFloat = 0
    var runningState: RunningState = .started
    var initialTime: TimeInterval = CACurrentMediaTime()
    var previousTime: Int = -1

    let pipe = Pipe()
    
}

extension GameScene {
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 1)
        addChild(pipe)
    }
    
}

extension GameScene {
    
    override func update(_ currentTime: TimeInterval) {
        let time = Int((currentTime - initialTime).rounded())
        let reachedNextSecond = time != previousTime
        if runningState == .shooting && time % 1 == 0 && reachedNextSecond {
            previousTime = time
            power += 250
        }
    }

}

extension GameScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if runningState == .started {
            runningState = .shooting
        }
        if runningState == .released {
            power = 0
            returnBall()
            runningState = .started
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if runningState == .shooting {
            runningState = .released
            shootBall()
        }
    }
    
}

extension GameScene {
    
    func getBall() -> Ball? {
        for pipeNode in pipe.children {
            if let ball = pipeNode as? Ball {
                return ball
            }
        }
        return nil
    }
    
    func shootBall() {
        getBall()?.physicsBody?.velocity.dx = power
    }
    
    func returnBall() {
        let ball = getBall()
        ball?.physicsBody?.velocity = .init(dx: 0, dy: 0)
        ball?.physicsBody?.angularVelocity = 0
        ball?.position = pipe.initialBallPos
    }
    
}

extension GameScene {
    
    enum RunningState {
        case started
        case shooting
        case released
    }
    
}
