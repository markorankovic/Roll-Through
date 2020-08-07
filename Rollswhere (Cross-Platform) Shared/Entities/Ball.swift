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
        
        node.physicsBody?.categoryBitMask = fixedCategory | moveableContactCategory | gateButtonContactCategory
        node.physicsBody?.collisionBitMask = ballCategory
        node.physicsBody?.contactTestBitMask = ballContactCategory
        node.physicsBody?.usesPreciseCollisionDetection = true
        
        addComponent(PhysicsComponent(physicsBody: node.physicsBody!))  
    }  
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    } 
    
}
