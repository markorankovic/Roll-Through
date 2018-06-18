//
//  Block.swift
//  Rollswhere (W GameplayKit)
//
//  Created by Marko on 01/06/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import GameplayKit

class Block: GKEntity {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(position: CGPoint, size: CGSize, fillColor: UIColor, physicsBody: SKPhysicsBody) {
        super.init()
        let shapeNode = SKShapeNode(rectOf: size) 
        shapeNode.physicsBody = physicsBody
        shapeNode.physicsBody?.affectedByGravity = false
        shapeNode.strokeColor = .black
        shapeNode.fillColor = fillColor
        shapeNode.position = position
        shapeNode.zPosition = 9 
        addComponent(ShapeComponent(shapeNode: shapeNode)) 
    }
    
} 


