//
//  Pipe.swift
//  Rollswhere
//
//  Created by Marko on 08/04/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import SpriteKit

class Pipe/*Node*/: SKShapeNode {
        
    override init() {
        
        super.init()
        
    }
    
    convenience init(position: CGPoint) {
        self.init()
        
        self.position = position
        let width: CGFloat = 120
        let height: CGFloat = 400
        path = Block(position: position, size: CGSize(width: width, height: height)).path
        
        let physicsbody1 = SKPhysicsBody(edgeFrom: CGPoint(x: -width/2, y: height/2), to: CGPoint(x: -width/2, y: -height/2))
        let physicsbody2 = SKPhysicsBody(edgeFrom: CGPoint(x: width/2, y: height/2), to: CGPoint(x: width/2, y: -height/2))
        
        physicsBody = SKPhysicsBody(bodies: [physicsbody1, physicsbody2])
        physicsBody?.isDynamic = false
        
        fillColor = .gray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
