//
//  Level.swift
//  Rollswhere (W GameplayKit)
//
//  Created by Marko on 13/06/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

class Level {
    
    let fixedPlatform: BounceBlock
    let blocks: [BounceBlock]
    let obstacles: [Obstacle] 
    let entryPipe: PipeBlock
    let exitPipe: PipeBlock 
    
    init(fixedPlatform: BounceBlock, blocks: [BounceBlock], obstacles: [Obstacle], entryPipe: PipeBlock, exitPipe: PipeBlock) {
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

