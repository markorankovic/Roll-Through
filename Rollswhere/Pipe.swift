//
//  Pipe.swift
//  Rollswhere
//
//  Created by Marko on 08/04/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import SpriteKit

class Pipe: SKShapeNode {
    
    let initialBallPos: CGPoint = .init(x: 0, y: -200)
    
    override init() {
        
        super.init()
        
        let ball = Ball()
        ball.position = initialBallPos
        ball.zPosition = -1
        
        let fixedBlock = Block(width: 200, height: 50)
        fixedBlock.position.y -= 400
        
        path = Block(width: 100, height: 400).path
        physicsBody?.categoryBitMask = 0
        
        position = .init(x: -300, y: 400)
        
        fillColor = .gray
        
        addChild(ball)
        addChild(fixedBlock)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
