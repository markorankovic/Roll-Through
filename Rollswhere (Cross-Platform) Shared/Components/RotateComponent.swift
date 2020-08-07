//
//  RotateComponent.swift
//  Rollswhere (ReturnTo-GKEntities)
//
//  Created by Marko on 09/08/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import GameplayKit

#if os(OSX)

//extension NSPoint {
//
//    static func *(lhs: NSPoint, rhs: CGFloat) -> NSPoint {
//        return NSPoint(x: lhs.x * rhs, y: lhs.y * rhs)
//    }
//
//}

#endif

class RotateComponent: GKComponent {
        
    var geometryComponent: GeometryComponent? {
        return entity?.component(ofType: GeometryComponent.self)
    }
    
    var physicsComponent: PhysicsComponent? {
        return entity?.component(ofType: PhysicsComponent.self)
    }
    
    var touchedBlock: Bool = false
    
    var rKeyHeld: Bool = false
    
    func returnToOriginalRotation() {
        if let originalRot = geometryComponent?.originalRotation {
            geometryComponent?.node?.run(.rotate(toAngle: originalRot, duration: 1))
        } 
    }
    
    #if os(iOS)
    
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
    
    #else
    
    func rKeyDown() {
        print("Can rotate")
        rKeyHeld = true
    }
    
    func rKeyReleased() {
        print("Can't rotate")
        rKeyHeld = false
    }
    
    func panGestureHandler(_ gestureRecognizer: NSPanGestureRecognizer) {
        guard rKeyHeld else {
            return
        }
        guard let scene = game.scene else {
            return
        }
        guard let view = scene.view else {
            return
        }
        if gestureRecognizer.state == .began {
            let potentialDraggableNode = scene.nodes(at: scene.convertPoint(fromView: gestureRecognizer.location(in: view))).first
            if let node = potentialDraggableNode {
                if let disabled = entity?.component(ofType: DragComponent.self)?.disabled {
                    touchedBlock = (node == geometryComponent?.node || node == geometryComponent?.node?.children.first) && !disabled
                } else {
                    touchedBlock = (node == geometryComponent?.node || node == geometryComponent?.node?.children.first)
                }
            }
        }
        geometryComponent?.node?.zRotation += touchedBlock ? -gestureRecognizer.velocityF(view: view) * 0.001 : 0
        print("macOS RotateComponent gesture recognizer")
        print("velocity: \(gestureRecognizer.velocityF(view: view))")
        print()
    }

    #endif
    
}



#if os(OSX)

extension NSPanGestureRecognizer {
    
    func velocityF(view: NSView) -> CGFloat {
        let v = velocity(in: view)
        let negative = v.x < 0
        return hypot(v.x, v.y) * (negative ? -1 : 1)
    }
    
}

#endif
