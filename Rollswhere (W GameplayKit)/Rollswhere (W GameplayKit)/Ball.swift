//
//  Ball.swift
//  Rollswhere (W GameplayKit)
//
//  Created by Marko on 01/06/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import GameplayKit

class Ball: GKEntity {
    
    var power: CGFloat = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(position: CGPoint, radius: CGFloat, fillColor: UIColor) {
        super.init()
        let shapeNode = SKShapeNode(ellipseOf: .init(width: radius * 2, height: radius * 2))
        let powerBar = SKShapeNode(rectOf: .init(width: 0, height: 10))
        powerBar.position.y = radius + 20
        powerBar.name = "power-bar"
        shapeNode.addChild(powerBar)
        powerBar.strokeColor = .red
        powerBar.lineWidth = 0
        shapeNode.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        shapeNode.physicsBody?.restitution = 0.4
        shapeNode.strokeColor = .black
        shapeNode.fillColor = fillColor
        shapeNode.position = position
        addComponent(ShapeComponent(shapeNode: shapeNode))
    }
    
}
 
