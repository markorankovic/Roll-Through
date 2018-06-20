//
//  WaitingState.swift
//  Rollswhere (W GameplayKit)
//
//  Created by Marko on 01/06/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import GameplayKit

extension CGPoint {
    
    func hypot2(point: CGPoint) -> CGFloat {
        return hypot(self.x - point.x, self.y - point.y)
    }
    
}

class WaitingState: GameState {
    
    var applyingPowerToBall = false
    
    var draggingBlock: SKShapeNode?
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return PauseState.self == stateClass || ShootingState.self == stateClass
    }
    
    func evaluateDrag(touch: UITouch) {
        let touchLocation = touch.location(in: scene)
        let prevTouchLocation = touch.previousLocation(in: scene)
        if let block = draggingBlock {
            block.run(.moveBy(x: touchLocation.x - prevTouchLocation.x, y: touchLocation.y - prevTouchLocation.y, duration: 0))
        }
    }
    
    func evaluateRotation(touch1: UITouch, touch2: UITouch) {
        let t1Loc = touch1.location(in: scene)
        let t1PrevLoc = touch1.previousLocation(in: scene)
        let t2Loc = touch2.location(in: scene)
        let t2PrevLoc = touch2.previousLocation(in: scene)
        let iTheta = atan((t1PrevLoc.y - t2PrevLoc.y) / (t1PrevLoc.x - t2PrevLoc.x))
        let fTheta = atan((t1Loc.y - t2Loc.y) / (t1Loc.x - t2Loc.x))
        let dTheta = fTheta - iTheta
        if let block = draggingBlock {
            block.run(.rotate(byAngle: dTheta, duration: 0))
        } 
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let selectedNodes = scene.nodes(at: touches.first!.location(in: scene))
        applyingPowerToBall = selectedNodes.first == scene.ball
        if let selectedNode = selectedNodes.first as? SKShapeNode {
            for block in scene.level.blocks {
                if selectedNode == block {
                    draggingBlock = selectedNode 
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch touches.count {
            case 1: evaluateDrag(touch: touches.first!)
            case 2: evaluateRotation(touch1: touches.first!, touch2: touches.reversed().first!)
            default: break
        }
    } 
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        draggingBlock = nil
        
        if let powerBar = scene.ball.children.first as? SKShapeNode {
            powerBar.lineWidth = 0
        }
        
        if applyingPowerToBall && scene.ball.physicsBody!.allContactedBodies().count == 1 && scene.power > 0 {
            stateMachine?.enter(ShootingState.self)
        } 
        
        applyingPowerToBall = false

    }
        
    override func didEnter(from previousState: GKState?) {
        print("Entered waiting")
    }
    
    func increaseBallPower() {
        scene.power += 50
    }
    
    func increasePowerBarWidth() {
        if let powerBar = scene.ball.children.first as? SKShapeNode {
            powerBar.lineWidth += 1
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if applyingPowerToBall && scene.ball.physicsBody!.allContactedBodies().count == 1 {
            increaseBallPower()
            increasePowerBarWidth()
            print("Power: \(scene.power)")
        }
    }
    
}

