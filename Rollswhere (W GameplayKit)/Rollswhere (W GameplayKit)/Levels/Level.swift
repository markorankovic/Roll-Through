//
//  Level.swift
//  Rollswhere (W GameplayKit)
//
//  Created by Marko on 13/06/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import SpriteKit

class Level {
    
    let fixedPlatform: SKShapeNode
    let blocks: [SKShapeNode]
    let obstacles: [SKShapeNode]
    let entryPipe: SKShapeNode
    let exitPipe: SKShapeNode
    
    init(fixedPlatform: SKShapeNode, blocks: [SKShapeNode], obstacles: [SKShapeNode], entryPipe: SKShapeNode, exitPipe: SKShapeNode) {
        self.fixedPlatform = fixedPlatform 
        self.blocks = blocks
        self.obstacles = obstacles
        self.entryPipe = entryPipe
        self.exitPipe = exitPipe
    } 
    
}

let levels: [Level] = [
    level1,
    level2, 
    level3,
    level4
]

