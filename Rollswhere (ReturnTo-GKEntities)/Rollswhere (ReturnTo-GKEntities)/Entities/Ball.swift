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
    
    convenience init(node: SKNode) {
        self.init()
        addComponent(GeometryComponent(node: node))
        addComponent(PlayerControlComponent())
        node.physicsBody?.collisionBitMask = 1
        addComponent(PhysicsComponent(physicsBody: node.physicsBody!))  
    }  
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    } 
    
}
