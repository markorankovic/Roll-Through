//
//  SpeedBoostComponent.swift
//  Rollswhere (ReturnTo-GKEntities)
//
//  Created by Marko on 20/07/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import GameplayKit

class SpeedBoostComponent: GKComponent {
    
    var geometryComponent: GeometryComponent? {
        return entity?.component(ofType: GeometryComponent.self)
    }
    
    var physicsComponent: PhysicsComponent? {
        return entity?.component(ofType: PhysicsComponent.self)
    }
    
    var didShoot: Bool = false
    
    func reactToNode(node: SKNode) {
        if let nodeBody = node.physicsBody {
            if let geometryNode = geometryComponent?.node {
                if let physicsBody = physicsComponent?.physicsBody {
                    if let speed = geometryNode.userData?["speed"] as? CGFloat {
                        if physicsBody.allContactedBodies().contains(nodeBody) {
                            //if !didShoot {
                                nodeBody.velocity.dx = speed * cos(geometryNode.zRotation)
                                nodeBody.velocity.dy = speed * sin(geometryNode.zRotation)
                                print("Speed: \(nodeBody.velocity)")
                                //didShoot = true
                            //}
                        } else {
                            //didShoot = false
                        }
                    }
                }
            }
        }
    }
    
}
