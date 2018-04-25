//
//  Ball.swift
//  Rollswhere
//
//  Created by Marko on 08/04/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import SpriteKit

class Ball: SKShapeNode {
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        super.init()
        path = SKShapeNode(ellipseOf: CGSize(width: 100, height: 100)).path
        fillColor = .green
        physicsBody = SKPhysicsBody(circleOfRadius: 50)
        physicsBody?.categoryBitMask = 1
        
        let launchBar = SKSpriteNode(color: .red, size: .init(width: 10, height: 10))
        launchBar.run(.scaleX(to: 0, duration: 0))
        launchBar.position.y += 100
        addChild(launchBar)
    }
    
}
