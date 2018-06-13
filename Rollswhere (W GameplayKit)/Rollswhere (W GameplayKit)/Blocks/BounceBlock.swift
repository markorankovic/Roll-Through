//
//  BounceBlock.swift
//  Rollswhere (W GameplayKit)
//
//  Created by Marko on 01/06/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import SpriteKit

class BounceBlock: Block {
    init(position: CGPoint, size: CGSize, fillColor: UIColor) {
        let physicsBody = SKPhysicsBody(edgeLoopFrom: .init(x: -size.width/2, y: -size.height/2, width: size.width, height: size.height))
        super.init(position: position, size: size, fillColor: fillColor, physicsBody: physicsBody)
    }  
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
} 
