//
//  RotateComponent.swift
//  Rollswhere (ReturnTo-GKEntities)
//
//  Created by Marko on 09/08/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import GameplayKit

class RotateComponent: GKComponent {
        
    var geometryComponent: GeometryComponent? {
        return entity?.component(ofType: GeometryComponent.self)
    }
    
    var physicsComponent: PhysicsComponent? {
        return entity?.component(ofType: PhysicsComponent.self)
    }
    
    var touchedBlock: Bool = false
    
    func returnToOriginalRotation() {
        if let originalRot = geometryComponent?.originalRotation {
            geometryComponent?.node?.run(.rotate(toAngle: originalRot, duration: 1))
        } 
    }
    
    func rotateGestureHandler(_ gestureRecognizer: UIRotationGestureRecognizer) {
        guard let scene = game.scene else { 
            return
        }
        guard let view = scene.view else {
            return
        }
        if gestureRecognizer.state == .began {
            let potentialDraggableNode = scene.nodes(at: scene.convertPoint(fromView: gestureRecognizer.location(in: view))).first
            if let ballBody = scene.childNode(withName: "ball")?.physicsBody {
                if let node = potentialDraggableNode {
                    if let nodeBody = node.physicsBody {
                        touchedBlock = (node == geometryComponent?.node || node == geometryComponent?.node?.children.first) && !nodeBody.allContactedBodies().contains(ballBody)
                    }
                }
            }
        }
        geometryComponent?.node?.zRotation += touchedBlock ? -gestureRecognizer.velocity * 0.01 : 0
    }
    
}
