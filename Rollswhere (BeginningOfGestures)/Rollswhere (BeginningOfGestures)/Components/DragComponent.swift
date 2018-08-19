//
//  DragComponent.swift
//  Rollswhere (ReturnTo-GKEntities)
//
//  Created by Marko on 23/06/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import GameplayKit

extension CGPoint {
    
    static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
}

class DragComponent: GKComponent {
    
    var geometryComponent: GeometryComponent? {
        return entity?.component(ofType: GeometryComponent.self)
    }
    
    var touchedBlock: Bool = false
    
    func panGestureHandler(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let scene = game.scene else {
            return
        } 
        guard let view = scene.view else {
            return
        }
        if gestureRecognizer.state == .began {
            if let node = scene.nodes(at: scene.convertPoint(fromView: gestureRecognizer.location(in: view))).first {
                touchedBlock = node == geometryComponent?.node
            }
        }
        let velocity = gestureRecognizer.velocity(in: view)
        let dragVelocity = CGPoint(x: velocity.x * 0.01, y: velocity.y * -0.01)
        if let node = geometryComponent?.node {
            node.position = node.position + ((gestureRecognizer.state != .ended && touchedBlock) ? dragVelocity : CGPoint()) 
        }
    }
    
}
