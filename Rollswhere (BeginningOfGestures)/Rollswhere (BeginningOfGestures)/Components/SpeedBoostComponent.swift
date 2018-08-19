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
    
    var didShoot: Bool = false
    
    func reactToNode(node: SKNode) {
        if let nodeBody = node.physicsBody {
            if let speedBoostNode = geometryComponent?.node {
                if speedBoostNode.calculateAccumulatedFrame().intersects(node.frame) {
                    if !didShoot { 
                        nodeBody.velocity.dx = -1000 * cos((speedBoostNode.zRotation * 180) / CGFloat.pi)
                        nodeBody.velocity.dy = -1000 * sin((speedBoostNode.zRotation * 180) / CGFloat.pi)
                        print("Speed: \(nodeBody.velocity)") 
                        didShoot = true
                    } 
                } else {
                    didShoot = false
                } 
            }
        }
    }
    
}
