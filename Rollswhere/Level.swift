//
//  Level.swift
//  Rollswhere
//
//  Created by Marko on 17/04/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

class Level {
    
    let fixedBlocks: [Block]
    let blocks: [Block]
    let pipe: Pipe
    let goal: Pipe
    
    init(fixedBlocks: [Block], blocks: [Block], pipe: Pipe, goal: Pipe) {
        self.fixedBlocks = fixedBlocks
        self.blocks = blocks
        self.pipe = pipe
        self.goal = goal
    }
    
}



