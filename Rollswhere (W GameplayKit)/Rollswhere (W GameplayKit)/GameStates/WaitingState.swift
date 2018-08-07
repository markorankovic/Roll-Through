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

    var draggingBlocks: [GKEntity] = []
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return PauseState.self == stateClass || ShootingState.self == stateClass
    }
    
    func getDraggingBlocks(touches: Set<UITouch>) -> [GKEntity] {
        var touchedNodes: Set<SKNode> = []
        for touch in touches {
            for node in (game.scene!.nodes(at: touch.location(in: game.scene!))) {
                touchedNodes.insert(node)
            }
        }
        let draggingBlocks = game.entities.filter({ $0 is BounceObject && $0.component(ofType: DragComponent.self) != nil && touchedNodes.contains(($0.component(ofType: GeometryComponent.self)?.node)!) })   
        return draggingBlocks
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        ball?.component(ofType: PlayerControlComponent.self)?.touchesBegan(touches, with: event)
        draggingBlocks = getDraggingBlocks(touches: touches)
    }
 
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        ball?.component(ofType: PlayerControlComponent.self)?.touchesMoved(touches, with: event)
        for block in draggingBlocks {
            block.component(ofType: DragComponent.self)?.touchesMoved(touches, with: event)
        }
        evaluateCameraMovement(touches)
    }
    
    func evaluateCameraMovement(_ touches: Set<UITouch>) {
        guard let scene = game.scene else {
            return
        } 
        guard touches.count == 2 else {
            return
        }
        game.scene?.camera?.run(.moveBy(x: touches.first!.location(in: scene).x - touches.first!.previousLocation(in: scene).x, y: touches.reversed().first!.location(in: scene).y - touches.reversed().first!.previousLocation(in: scene).y, duration: 0.1))
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        ball?.component(ofType: PlayerControlComponent.self)?.touchesEnded(touches, with: event)
        draggingBlocks = getDraggingBlocks(touches: touches)
        for block in draggingBlocks {
            block.component(ofType: DragComponent.self)?.touchesEnded(touches, with: event)
        }  
    }

    override func didEnter(from previousState: GKState?) {
        ball?.component(ofType: PlayerControlComponent.self)?.resetPowerBar()  
        ball?.component(ofType: PlayerControlComponent.self)?.addPowerBar()
        //testShoot()
        print("Entered waiting") 
    }
    
    func testShoot() {
        ball?.component(ofType: PlayerControlComponent.self)?.power = 500
        stateMachine?.enter(ShootingState.self) 
    }

    override func update(deltaTime seconds: TimeInterval) {
        ball?.component(ofType: PlayerControlComponent.self)?.update(deltaTime: seconds) 
    }

}


