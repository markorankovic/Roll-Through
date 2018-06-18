//
//  Level1.swift
//  Rollswhere (W GameplayKit)
//
//  Created by Marko on 13/06/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import SpriteKit


private let fixedBlock = BounceBlock(position: .init(x: -300, y: 100), size: CGSize(width: 200, height: 50), fillColor: .red)
private let entryPipe = PipeBlock(position: .init(x: -300, y: 600), size: .init(width: 150, height: 400), fillColor: .gray)
private let exitPipe = PipeBlock(position: .init(x: 400, y: -450), size: .init(width: 150, height: 500), fillColor: .gray)

let level1 = Level( 
    fixedPlatform: fixedBlock,
    blocks: [],
    obstacles: [],
    entryPipe: entryPipe,
    exitPipe: exitPipe
) 


