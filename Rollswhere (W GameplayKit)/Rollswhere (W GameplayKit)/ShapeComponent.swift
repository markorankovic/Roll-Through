//
//  ShapeComponent.swift
//  Rollswhere (W GameplayKit)
//
//  Created by Marko on 01/06/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import GameplayKit

class ShapeComponent: GKComponent {
    
    var shapeNode: SKShapeNode!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(shapeNode: SKShapeNode) {
        super.init()
        self.shapeNode = shapeNode
    }
    
} 
