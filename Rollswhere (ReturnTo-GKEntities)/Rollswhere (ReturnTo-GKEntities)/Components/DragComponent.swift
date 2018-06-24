//
//  DragComponent.swift
//  Rollswhere (ReturnTo-GKEntities)
//
//  Created by Marko on 23/06/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import GameplayKit

class DragComponent: GKComponent {
    
    var shapeComponent: ShapeComponent? {
        return entity?.component(ofType: ShapeComponent.self)
    }
    
    func evaluateDrag(touch: UITouch) {
        let touchLocation = touch.location(in: game.scene!)
        let prevTouchLocation = touch.previousLocation(in: game.scene!)
        if let block = shapeComponent?.shapeNode {
            block.run(.moveBy(x: touchLocation.x - prevTouchLocation.x, y: touchLocation.y - prevTouchLocation.y, duration: 0))
        }
    }
    
    func evaluateRotation(touch1: UITouch, touch2: UITouch) {
        let t1Loc = touch1.location(in: game.scene!)
        let t1PrevLoc = touch1.previousLocation(in: game.scene!)
        let t2Loc = touch2.location(in: game.scene!)
        let t2PrevLoc = touch2.previousLocation(in: game.scene!)
        let iTheta = atan((t1PrevLoc.y - t2PrevLoc.y) / (t1PrevLoc.x - t2PrevLoc.x))
        let fTheta = atan((t1Loc.y - t2Loc.y) / (t1Loc.x - t2Loc.x))
        let dTheta = fTheta - iTheta
        if let block = shapeComponent?.shapeNode {
            block.run(.rotate(byAngle: dTheta, duration: 0))
        }
    }
    
    func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch touches.count {
            case 1: evaluateDrag(touch: touches.first!)
            case 2: evaluateRotation(touch1: touches.first!, touch2: touches.reversed().first!)
            default: break
        }
    }
        
}
