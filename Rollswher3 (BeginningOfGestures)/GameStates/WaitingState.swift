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
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return PauseState.self == stateClass || ShootingState.self == stateClass
    }
    
    override func longPressGestureHandler(_ gestureRecognizer: UILongPressGestureRecognizer) {
        game.scene?.camera?.run(.move(to: .init(), duration: 0.5))
    }
    
    override func swipeGestureHandler(_ gestureRecognizer: UISwipeGestureRecognizer) {
        guard let scene = game.scene else {
            return
        }
        guard let view = scene.view else {
            return
        }
        guard let camera = scene.camera else {
            return
        }
        guard let backgroundNode = scene.childNode(withName: "background") else {
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
    
    override func panGestureHandler(_ gestureRecognizer: UIPanGestureRecognizer) {
        ball?.component(ofType: PlayerControlComponent.self)?.panGestureHandler(gestureRecognizer)
        for block in game.entities.filter({ $0.component(ofType: DragComponent.self) != nil }) {
            block.component(ofType: DragComponent.self)?.panGestureHandler(gestureRecognizer)
        }
    }
    
    override func rotateGestureHandler(_ gestureRecognizer: UIRotationGestureRecognizer) {
        for block in game.entities.filter({ $0.component(ofType: DragComponent.self) != nil }) {
            block.component(ofType: RotateComponent.self)?.rotateGestureHandler(gestureRecognizer)
        } 
    }
    
    override func didEnter(from previousState: GKState?) {
        ball?.component(ofType: PlayerControlComponent.self)?.resetPowerBar()  
        ball?.component(ofType: PlayerControlComponent.self)?.addPowerBar()
        print("Entered waiting")
    }
    
}


