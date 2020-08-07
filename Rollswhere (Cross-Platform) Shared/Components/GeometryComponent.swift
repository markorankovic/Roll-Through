//
//  GeometryComponent.swift
//  Rollswhere (ReturnTo-GKEntities)
//
//  Created by Marko on 20/06/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import GameplayKit

class GeometryComponent: GKComponent {
    
    var node: SKNode?
    var originalPosition: CGPoint?
    var originalRotation: CGFloat? 
    
    init(node: SKNode) {
        super.init()
        self.node = node  
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
