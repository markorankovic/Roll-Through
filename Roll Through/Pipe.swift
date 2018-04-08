//
//  Pipe.swift
//  Roll Through
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
        
        let fixedBlock = Block(width: 200, height: 50)
        fixedBlock.position.y -= 400
        
        let pipeBlock = Block(width: 100, height: 400)
        pipeBlock.physicsBody?.categoryBitMask = 0
        
        position.y = 400
        position.x = -300
        
        pipeBlock.fillColor = .gray
        
        addChild(ball)
        addChild(pipeBlock)
        addChild(fixedBlock)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
