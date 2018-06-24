//
//  BounceObject.swift .swift
//  Rollswhere (ReturnTo-GKEntities)
//
//  Created by Marko on 20/06/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import GameplayKit

class BounceObject: GKEntity {
    
    override init() {
        super.init()
    }
    
    convenience init(shapeNode: SKShapeNode, physicsBody: SKPhysicsBody) {
        self.init()
        addComponent(ShapeComponent(shapeNode: shapeNode))
        addComponent(PhysicsComponent(physicsBody: physicsBody))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
