//
//  GameScene.swift
//  Rollswhere
//
//  Created by Marko on 08/04/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import SpriteKit

let level1 = Level(
    fixedBlocks: [Block(position: .init(x: -300, y: 0), size: CGSize(width: 200, height: 50), fixed: true)],
    blocks: [Block(position: .init(x: 0, y: 50), size: CGSize(width: 300, height: 30))],
    pipe: Pipe(position: .init(x: -300, y: 400)),
    goal: Pipe(position: .init(x: -100, y: -300))
)

let level2 = Level(
    fixedBlocks: [Block(position: .init(x: -400, y: 0), size: CGSize(width: 200, height: 50), fixed: true)],
    blocks: [Block(position: .init(x: 0, y: 50), size: CGSize(width: 300, height: 30))],
    pipe: Pipe(position: .init(x: -400, y: 400)),
    goal: Pipe(position: .init(x: 200, y: -300))
)

class GameScene: SKScene {
    
    var power: CGFloat = 0
    
    var runningState: RunningState = .started {
        willSet {
            if newValue == .shooting {
                countFrom = time
            }
        }
    }
    
    var time: TimeInterval = CACurrentMediaTime()
    var countFrom: Double = CACurrentMediaTime()

    let ball = Ball()
    var draggingBlock: Block? = nil
    var lastAcceptedPosition: CGPoint? = CGPoint()
    var lastAcceptedRotation: CGFloat? = CGFloat()
    var ballHitObject: Bool = false
    var level = level2
    
}

extension GameScene {
    
    override func didMove(to view: SKView) {
        
        initScene(view)
        
        resetBallPosition()
        addChild(ball)
        addChild(level.pipe)
        addChild(level.fixedBlocks[0])
        addChild(level.goal)
        addChild(level.blocks[0])
        
    }
    
    func initScene(_ view: SKView) {
        backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 1)

        size = view.bounds.size
        scaleMode = .aspectFill
        anchorPoint = .init(x: 0.5, y: 0.5) 
        //physicsBody = SKPhysicsBody(edgeLoopFrom: .init(origin: .init(x: -view.frame.width/2, y: -view.frame.height/2), size: view.frame.size))
    }
    
}

extension GameScene {
    
    func toggleBlockPhysics(isActive: Bool) {
        draggingBlock?.physicsBody?.categoryBitMask = isActive ? 1 : 0
    }
    
}

//extension GameScene {
//
//    func ballHitFixedBlock(block: Block) -> Bool {
//
//    }
//
//}

extension GameScene {
    
    override func update(_ currentTime: TimeInterval) {
        
        if ball.physicsBody!.allContactedBodies().count > 0 {
            ballHitObject = true
        }
        
        if ball.physicsBody?.velocity.dy == 0 && ball.physicsBody?.velocity.dx == 0 && runningState == .started && ballHitObject {
            runningState = .waiting
        }
        
        if runningState == .dragging {
            toggleBlockPhysics(isActive: false)
        }
        
        time = currentTime
        let intervalPassed = Int((time - countFrom) * 5) == 1
        
        if runningState == .shooting && intervalPassed {
            power += 250
            ball.children[0].run(.scale(to: .init(width: power/10, height: 10), duration: 0))
            countFrom = time
        }
        
    }

}

extension GameScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.count == 1 else {
            return
        }
        
        if runningState == .waiting {
            if nodes(at: touches.first!.location(in: self)).first is Ball {
                runningState = .shooting
            }
        }
        
        if runningState == .released {
            power = 0
            returnBall()
            runningState = .started
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if runningState == .dragging {
            evaluateBlockPlacement()
            evaluateBlockDiversion()
            runningState = .waiting
            toggleBlockPhysics(isActive: true)
        }
        
        draggingBlock = nil
        
        if power == 0 && runningState == .released {
            runningState = .waiting
        }
        
        if runningState == .shooting {
            runningState = .released
            ball.children[0].run(.scaleX(to: 0, duration: 0))
            shootBall()
        }
        
    }
    
    func evaluateBlockPlacement() {
        guard draggingBlock != nil else {
            assertionFailure("Dragging block is nil")
            return
        }
        if draggingBlock!.physicsBody!.allContactedBodies().count > 0 {
            draggingBlock!.position = lastAcceptedPosition!
        } else {
            lastAcceptedPosition = draggingBlock?.position
        }
    }
    
    func evaluateBlockDiversion() {
        guard draggingBlock != nil else {
            assertionFailure("Dragging block is nil")
            return
        }
        if draggingBlock!.physicsBody!.allContactedBodies().count > 0 {
            draggingBlock!.zRotation = lastAcceptedRotation!
        } else {
            lastAcceptedRotation = draggingBlock?.zRotation
        }
    }
    
    func evaluateDrag(_ touch: UITouch) {
        let currentLocation = touch.location(in: self)
        let previousLocation = touch.previousLocation(in: self)
        if let block = draggingBlock {
            if !block.fixed {
                runningState = .dragging
                let cos = currentLocation.x - previousLocation.x
                let sin = currentLocation.y - previousLocation.y
                block.run(.move(by: .init(dx: cos, dy: sin), duration: 0))
            }
        }
    }
    
    func evaluateRotation(_ touch1: UITouch, _ touch2: UITouch) {
        let currentLocation = touch1.location(in: self)
        if let block = draggingBlock {
            if !block.fixed {
                block.run(.rotate(toAngle: atan2(currentLocation.y - touch2.location(in: self).y, currentLocation.x - touch2.location(in: self).x), duration: 0))
            }
        }
    }
    
    func getPotentialDraggingBlock(location: CGPoint) -> Block? {
        let unFixedBlocksAtLocation = (nodes(at: location).filter{ $0 is Block } as! [Block]).filter{ !$0.fixed }
        return unFixedBlocksAtLocation.count > 0 ? unFixedBlocksAtLocation[0] : nil
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard touches.count > 0 && runningState != .started else {
            return
        }
        
        if let potentialDraggingBlock = getPotentialDraggingBlock(location: touches.first!.location(in: self)) {
            draggingBlock = potentialDraggingBlock
        }
        
        if touches.count == 1 {
            evaluateDrag(touches.first!)
        }
        
        if touches.count == 2 {
            evaluateRotation(touches.first!, touches.reversed().first!)
        }
        
    }
    
}

extension GameScene {
    
    func resetBallPosition() {
        ball.position = level.pipe.position
    }
    
    func shootBall() {
        if (power > 0) {
            ball.physicsBody?.velocity.dx = power
        }
    }
    
    func returnBall() {
        ball.physicsBody?.velocity = .init(dx: 0, dy: 0)
        ball.physicsBody?.angularVelocity = 0
        ball.run(.rotate(toAngle: 0, duration: 0))
        resetBallPosition() 
    }
    
}

extension GameScene {
    
    enum RunningState {
        case started
        case waiting
        case shooting
        case dragging
        case released
    }
    
}
