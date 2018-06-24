//
//  Ball.swift
//  Rollswhere (ReturnTo-GKEntities)
//
//  Created by Marko on 20/06/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import GameplayKit

class Ball: GKEntity {
    
    override init() {
        super.init()
    }
    
    convenience init(shapeNode: SKShapeNode) {
        self.init()
        addComponent(ShapeComponent(shapeNode: shapeNode))
        addComponent(PlayerControlComponent())
        let physicsBody = SKPhysicsBody(circleOfRadius: (shapeNode.path?.boundingBox.size.width)! / 2)
        physicsBody.collisionBitMask = 1  
        addComponent(PhysicsComponent(physicsBody: physicsBody))
    }  
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
