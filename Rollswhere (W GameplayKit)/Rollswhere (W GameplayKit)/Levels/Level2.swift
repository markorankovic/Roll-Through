//
//  Level2.swift
//  Rollswhere (W GameplayKit)
//
//  Created by Marko on 13/06/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import SpriteKit


private let fixedBlock = BounceBlock(position: .init(x: -300, y: -200), size: CGSize(width: 200, height: 50), fillColor: .red)
private let entryPipe = PipeBlock(position: .init(x: -300, y: 600), size: .init(width: 150, height: 400), fillColor: .gray)
private let exitPipe = PipeBlock(position: .init(x: 400, y: -200), size: .init(width: 150, height: 1000), fillColor: .gray)
private let block = BounceBlock(position: .init(x: 0, y: 0) , size: CGSize(width: 200, height: 50), fillColor: .green)

let level2 = Level(
    fixedPlatform: fixedBlock,
    blocks: [block],
    obstacles: [],
    entryPipe: entryPipe,
    exitPipe: exitPipe
) 
 
