//
//  GameScene.swift
//  Rollswhere (W GameplayKit)
//
//  Created by Marko on 01/06/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, GestureHandler {
    
    
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
    
    
    func setCameraScale(xScale: CGFloat, yScale: CGFloat) {
        camera?.xScale = xScale
        camera?.yScale = yScale
    }
    
    override func didMove(to view: SKView) {
        
        let aspectRatio = view.frame.width / view.frame.height
        
        switch aspectRatio {
        case 16/9: setCameraScale(xScale: 1920 / max(size.width, size.height), yScale: 1080 / min(size.width, size.height))
        default: setCameraScale(xScale: 1920 / max(size.width, size.height), yScale: 1920 / max(size.width, size.height))
        }
        if let camera = camera {
//            camera.physicsBody = SKPhysicsBody(edgeLoopFrom: .init(origin: .init(x: -(size.width * camera.xScale)/2, y: -camera.calculateAccumulatedFrame().height/2), size: .init(width: size.width * camera.xScale, height: camera.calculateAccumulatedFrame().height)))
//            camera.physicsBody?.categoryBitMask = 0
            positionRollbackButton(camera)
        }
        game.stateMachine.enter(ReturnState.self)
    }
    
    func positionRollbackButton(_ camera: SKCameraNode) {
        if let rollbackButton = camera.childNode(withName: "rollback") as? SKSpriteNode {
            rollbackButton.position.x = -size.width / 2 + rollbackButton.size.width / 2
            rollbackButton.position.y = -size.height / 2 + rollbackButton.size.height / 2
        }
    }
    
}

extension GameScene {
    
    func evaluateRollback(entity: GKEntity, gestureRecognizer: UIPanGestureRecognizer) {
        if let rollbackButton = camera?.childNode(withName: "rollback") { 
            if let rollbackButtonBody = rollbackButton.physicsBody {
                if let node = entity.component(ofType: GeometryComponent.self)?.node {
                    if let nodeBody = node.physicsBody {
                        if let dragComponent = entity.component(ofType: DragComponent.self) {
                            if let rotateComponent = entity.component(ofType: RotateComponent.self) {
                                if rollbackButtonBody.allContactedBodies().contains(nodeBody) {
                                    (rollbackButton as? SKSpriteNode)?.texture = SKTexture(imageNamed: "rollback_confirm")
                                    if gestureRecognizer.state == .ended {
                                        dragComponent.returnToOriginalPosition()
                                        rotateComponent.returnToOriginalRotation()
                                        (rollbackButton as? SKSpriteNode)?.texture = SKTexture(imageNamed: "rollback")
                                    }
                                } else if rollbackButtonBody.allContactedBodies().filter({ $0.node?.name == "block" }).count == 0 {
                                    (rollbackButton as? SKSpriteNode)?.texture = SKTexture(imageNamed: "rollback")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
}

extension GameScene {
    
    func returnCamToCenter() {
        guard let camera = camera else {
            return
        }
        camera.run(.move(to: .init(), duration: 0.5))
    } 
    
    func panCamera(_ gestureRecognizer: UISwipeGestureRecognizer) {        
        switch gestureRecognizer.direction {
        case .right: attemptToMoveCamBy(vector: .init(dx: -600, dy: 0), duration: 0.5)
        case .left: attemptToMoveCamBy(vector: .init(dx: 600, dy: 0), duration: 0.5)
        case .up: attemptToMoveCamBy(vector: .init(dx: 0, dy: -600), duration: 0.5)
        case .down: attemptToMoveCamBy(vector: .init(dx: 0, dy: 600), duration: 0.5)
        default: break
        }
    }
    
    func tryMoveCamTo(node: SKNode) {
        if let camera = camera {
            let camWidth: CGFloat = size.width * camera.xScale
            let camHeight: CGFloat = size.height * camera.yScale
            if !CGRect(x: camera.position.x - camWidth/2, y: camera.position.y - camHeight/2, width: camWidth, height: camHeight).contains(node.frame) {
                attemptToMoveCamBy(vector: .init(dx: node.position.x - camera.position.x, dy: node.position.y - camera.position.y), duration: 0.3)
            }
        }
    }
    
    func attemptToMoveCamBy(vector: CGVector, duration: CGFloat) {
        guard let view = view else {
            print("view not found")
            return
        }
        guard let camera = camera else {
            print("camera not found")
            return
        }
        guard let background = childNode(withName: "background") else {
            print("background not found")
            return
        }
        guard !camera.hasActions() else {
            //print("camera already panning")
            return
        }
        
        let camSize = CGSize(width: view.bounds.width * camera.xScale, height: view.bounds.height * camera.yScale)
        let camViewPosition = CGPoint(x: camera.position.x - camSize.width/2, y: camera.position.y - camSize.height/2)
        let cAfterMoveFrame = CGRect(origin: .init(x: camViewPosition.x + vector.dx, y: camViewPosition.y + vector.dy), size: camSize)
        let bFrame = background.frame
                
        let intersection = bFrame.intersection(cAfterMoveFrame)
        if intersection.width == 0 || intersection.height == 0 {
            return
        }
        let xCamRemainder = floor(cAfterMoveFrame.width - intersection.width)
        let yCamRemainder = floor(cAfterMoveFrame.height - intersection.height)
        let action: SKAction = .move(by: .init(dx: vector.dx + (vector.dx < 0 ? xCamRemainder: -xCamRemainder), dy: vector.dy + (vector.dy < 0 ? yCamRemainder: -yCamRemainder)), duration: TimeInterval(duration))
        camera.run(action)
    }

}

extension GameScene { 
    override func update(_ currentTime: TimeInterval) {
        game.loop(time: currentTime)
        game.stateMachine.currentState?.update(deltaTime: currentTime)
    }
}
