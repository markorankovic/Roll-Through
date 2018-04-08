//
//  Block.swift
//  Roll Through
//
//  Created by Marko on 08/04/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import SpriteKit

class Block: SKShapeNode {
    
    var fixed = false
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        super.init()
    }
    
    convenience init(width: CGFloat, height: CGFloat) {
        self.init()
        path = SKShapeNode(rectOf: CGSize(width: width, height: height)).path
        physicsBody = SKPhysicsBody(edgeLoopFrom: path!)
        physicsBody?.affectedByGravity = false
    }
    
}
