//
//  DragComponent.swift
//  Rollswhere (ReturnTo-GKEntities)
//
//  Created by Marko on 23/06/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import GameplayKit

class DragComponent: GKComponent {
    
    var geometryComponent: GeometryComponent? {
        return entity?.component(ofType: GeometryComponent.self)
    }
    
    var physicsComponent: PhysicsComponent? {
        return entity?.component(ofType: PhysicsComponent.self)
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
        physicsComponent?.setVelocity(velocity: gestureRecognizer.state != .ended && touchedBlock ? CGVector(dx: velocity.x * 2, dy: -velocity.y * 1.5) : CGVector()) 
    }
    
}
