//
//  Block.swift
//  Rollswhere
//
//  Created by Marko on 08/04/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import SpriteKit

class Block/*Node*/: SKShapeNode {
    
    var fixed = false
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        super.init()
    }
    
    convenience init(position: CGPoint, size: CGSize, fixed: Bool = false) {
        self.init()
        fillColor = fixed ? .red : .blue
        path = SKShapeNode(rectOf: size).path
        physicsBody = SKPhysicsBody(edgeLoopFrom: path!)
        physicsBody?.affectedByGravity = false
        self.fixed = fixed
        self.position = position
    }
    
}
