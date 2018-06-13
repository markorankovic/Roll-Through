//
//  Obstacle.swift
//  Rollswhere (W GameplayKit)
//
//  Created by Marko on 13/06/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import GameplayKit
import SpriteKit

class Obstacle: GKEntity {
    
    init(position: CGPoint, path: CGPath) {
        super.init()
        let shapeNode = SKShapeNode(path: path)
        shapeNode.position = position 
        let physicsBody = SKPhysicsBody(edgeChainFrom: path)
        physicsBody.affectedByGravity = false 
        shapeNode.physicsBody = physicsBody 
        shapeNode.strokeColor = .black
        shapeNode.fillColor = .red
        addComponent((ShapeComponent(shapeNode: shapeNode)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
