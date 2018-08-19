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
        case 16/9: setCameraScale(xScale: 1920 / max(view.frame.width, view.frame.height), yScale: 1080 / min(view.frame.width, view.frame.height))
        default: setCameraScale(xScale: 1920 / max(view.frame.width, view.frame.height), yScale: 1920 / max(view.frame.width, view.frame.height)) 
        } 
        
        game.stateMachine.enter(ReturnState.self)
    } 
    
}

extension GameScene {
    
    func returnCamToCenter() {
        camera?.run(.move(to: .init(), duration: 0.5))
    } 
    
    func panCamera(_ gestureRecognizer: UISwipeGestureRecognizer) {
        guard let view = view else {
            return
        }
        guard let camera = camera else {
            return
        }
        guard let backgroundNode = childNode(withName: "background") else {
            return
        } 
        let leftSidePosition = camera.position.x - (view.bounds.size.width * camera.xScale)/2
        let leftSideToLeftSide = leftSidePosition - 600 - -backgroundNode.frame.width/2
        
        let rightSidePosition = camera.position.x + (view.bounds.size.width * camera.xScale)/2
        let rightSideToRightSide = backgroundNode.frame.width/2 - (rightSidePosition + 600)
        
        let topSidePosition = camera.position.y + (view.bounds.size.height * camera.yScale)/2
        let topSideToTopSide = backgroundNode.frame.height/2 - (topSidePosition + 600)
        
        let bottomSidePosition = camera.position.y - (view.bounds.size.height * camera.yScale)/2
        let bottomSideToBottomSide = (bottomSidePosition - 600) - -backgroundNode.frame.height/2
        
        switch gestureRecognizer.direction {
        case .right: camera.run(.moveBy(x: leftSideToLeftSide >= 0 ? -600 : -(leftSidePosition - -backgroundNode.frame.width/2), y: 0, duration: 0.5))
        case .left: camera.run(.moveBy(x: rightSideToRightSide >= 0 ? 600 : backgroundNode.frame.width/2 - rightSidePosition, y: 0, duration: 0.5))
        case .up: camera.run(.moveBy(x: 0, y: bottomSideToBottomSide >= 0 ? -600 : -(bottomSidePosition - -backgroundNode.frame.height/2), duration: 0.5))
        case .down: camera.run(.moveBy(x: 0, y: topSideToTopSide >= 0 ? 600 : backgroundNode.frame.height/2 - topSidePosition, duration: 0.5))
        default: break
        }
    }
    
    func tryMoveCamTo(node: SKNode) {
        if let camera = camera {
            if !camera.frame.contains(node.frame) {
                moveCamTo(node: node)
            } else {
                print(1) 
            }
        }
    }
    
    func moveCamTo(node: SKNode) {
        camera?.run(.move(to: node.position, duration: 0.3))
    } 
    
}

extension GameScene {  
    func swipeGestureHandler(_ gestureRecognizer: UISwipeGestureRecognizer) {
        (game.stateMachine.currentState as? GameState)?.swipeGestureHandler(gestureRecognizer)
    } 
    
    func panGestureHandler(_ gestureRecognizer: UIPanGestureRecognizer) {
        (game.stateMachine.currentState as? GameState)?.panGestureHandler(gestureRecognizer)
    }
    
    func tapGestureHandler(_ gestureRecognizer: UITapGestureRecognizer) {
        (game.stateMachine.currentState as? GameState)?.tapGestureHandler(gestureRecognizer)
    }
    
    func longPressGestureHandler(_ gestureRecognizer: UILongPressGestureRecognizer) {
        (game.stateMachine.currentState as? GameState)?.longPressGestureHandler(gestureRecognizer)
    }
    
    func rotationGestureHandler(_ gestureRecognizer: UIRotationGestureRecognizer) {
        (game.stateMachine.currentState as? GameState)?.rotationGestureHandler(gestureRecognizer)
    }
}

extension GameScene { 
    override func update(_ currentTime: TimeInterval) {
        game.loop(time: currentTime)
        game.stateMachine.currentState?.update(deltaTime: currentTime)
    }  
}
