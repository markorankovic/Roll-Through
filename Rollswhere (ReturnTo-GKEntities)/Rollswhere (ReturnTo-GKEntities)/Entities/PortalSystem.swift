//
//  PortalSystem.swift
//  Rollswhere (ReturnTo-GKEntities)
//
//  Created by Marko on 25/07/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import GameplayKit

class PortalSystem: GKEntity {
    
    override init() {
        super.init()
    }
    
    convenience init(node: SKNode) {
        self.init()
        addComponent(GeometryComponent(node: node))
        addComponent(PortalSystemControlComponent()) 
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
