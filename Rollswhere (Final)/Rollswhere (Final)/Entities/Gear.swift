//
//  Gear.swift
//  Rollswhere (BeginningOfGestures)
//
//  Created by Marko on 13/10/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import GameplayKit

class Gear: GKEntity {
    
    convenience init(node: SKNode) {
        self.init()
        addComponent(GeometryComponent(node: node))
        addComponent(RotateComponent())
    } 
    
}
