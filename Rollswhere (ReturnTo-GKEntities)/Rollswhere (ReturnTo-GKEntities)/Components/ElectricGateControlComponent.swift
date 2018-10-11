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
    
    var acted: Bool = false
    
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
        guard let userData = geometryComponent?.node?.userData else {
            return
        }
        guard let gate = geometryComponent?.node?.childNode(withName: "gate") else {
            return
        }
        gate.zRotation = 0
        if let originalXPos = userData["originalXPos"] as? CGFloat {
            if let originalYPos = userData["originalYPos"] as? CGFloat {
                gate.position = CGPoint(x: originalXPos, y: originalYPos)
            } 
        } 
    }
    
    func reactToNode(node: SKNode) {
        guard let nodeBody = node.physicsBody else {
            return
        }
        if let button = geometryComponent?.node?.childNode(withName: "button") {
            if let gate = geometryComponent?.node?.childNode(withName: "gate") {
                if (nodeBody.allContactedBodies().contains(button.physicsBody!)) {
                    openGate(gate)
                } else {
                    acted = false
                }
            }
        }
    }
    
}
