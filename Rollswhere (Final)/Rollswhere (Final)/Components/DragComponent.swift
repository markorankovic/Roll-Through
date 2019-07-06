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
    
    var physicsComponent: PhysicsComponent? {
        return entity?.component(ofType: PhysicsComponent.self)
    }
    
    var touchedBlock: Bool = false
    
    func returnToOriginalPosition() {
        if let originalPos = geometryComponent?.originalPosition {
            geometryComponent?.node?.run(.move(to: originalPos, duration: 1))
        }
    }
    
    func panGestureHandler(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let scene = game.scene else {
            return
        } 
        guard let view = scene.view else {
            return
        }
        guard let ballBody = scene.childNode(withName: "ball")?.physicsBody else {
            return
        }
        guard let physicsBody = physicsComponent?.physicsBody else {
            return
        }
        guard !physicsBody.allContactedBodies().contains(ballBody) else {
            return
        }
        if gestureRecognizer.state == .began {
            if let node = scene.nodes(at: scene.convertPoint(fromView: gestureRecognizer.location(in: view))).first {
                touchedBlock = node == geometryComponent?.node
            }
        }
        if let node = geometryComponent?.node {
            let deltaPosition = scene.convertPoint(fromView: gestureRecognizer.location(in: view)) - node.position
            node.position = node.position + ((gestureRecognizer.state != .ended && touchedBlock) ? deltaPosition : CGPoint())
        }
    }
    
}
