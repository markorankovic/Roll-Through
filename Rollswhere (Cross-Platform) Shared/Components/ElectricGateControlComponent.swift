//
//  ElectricGateControlComponent.swift
//  Rollswhere (ReturnTo-GKEntities)
//
//  Created by Marko on 26/07/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import GameplayKit

class ElectricGateControlComponent: GKComponent {
    
    var geometryComponent: GeometryComponent? {
        return entity?.component(ofType: GeometryComponent.self)
    }
    
    var originalGatePosition: CGPoint?
    
    var acted: Bool = false
    
    convenience init(originalGatePosition: CGPoint?) {
        self.init()
        self.originalGatePosition = originalGatePosition
    } 
    
    func openGate(_ gate: SKNode) {
        guard !acted else {
            return
        }
        guard let userData = geometryComponent?.node?.userData else {
            return
        }
        if let action = userData["action"] as? String {
            if action == "slide" {
                if let direction = userData["slideDirection"] as? String {
                    if let slideDistance = userData["slideDistance"] as? CGFloat {
                        switch direction {
                        case "up": gate.run(.move(by: .init(dx: 0, dy: slideDistance), duration: 0.1))
                        case "down": gate.run(.move(by: .init(dx: 0, dy: -slideDistance), duration: 0.1))
                        case "left": gate.run(.move(by: .init(dx: -slideDistance, dy: 0), duration: 0.1))
                        case "right": gate.run(.move(by: .init(dx: slideDistance, dy: 0), duration: 0.1))
                        default: break
                        } 
                    }
                } 
            } else if action == "rotate" {
                if let rotationAngle = userData["rotationAngle"] as? CGFloat {
                    gate.run(.rotate(byAngle: rotationAngle, duration: 0.1))
                } 
            }
            acted = true
        }
    }
    
    func closeGate() {
        guard let gate = geometryComponent?.node?.childNode(withName: "gate") else {
            return
        }
        gate.zRotation = 0
        if let originalGatePosition = originalGatePosition {
            gate.position = originalGatePosition
        } 
    }
    
    func reactToNode(node: SKNode) {
        guard let nodeBody = node.physicsBody else {
            return
        }
        if let buttonBody = geometryComponent?.node?.childNode(withName: "button")?.physicsBody {
            if let gate = geometryComponent?.node?.childNode(withName: "gate") {
                if (nodeBody.allContactedBodies().contains(buttonBody)) {
                    openGate(gate)
                } else {
                    acted = false
                }
            }
        }
    }
    
}
