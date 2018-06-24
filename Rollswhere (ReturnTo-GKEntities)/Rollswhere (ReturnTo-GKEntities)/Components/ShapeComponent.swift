//
//  ShapeComponent.swift
//  Rollswhere (ReturnTo-GKEntities)
//
//  Created by Marko on 20/06/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import GameplayKit

class ShapeComponent: GKComponent {
    
    var shapeNode: SKShapeNode?
    
    init(shapeNode: SKShapeNode) {
        super.init()
        self.shapeNode = shapeNode  
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
