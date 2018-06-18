//
//  Level4.swift
//  Rollswhere (W GameplayKit)
//
//  Created by Marko on 13/06/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import SpriteKit


private let fixedBlock = BounceBlock(position: .init(x: 400, y: 0), size: CGSize(width: 200, height: 50), fillColor: .red)
private let entryPipe = PipeBlock(position: CGPoint(x: 400, y: 800), size: .init(width: 150, height: 1000), fillColor: .gray)
private let exitPipe = PipeBlock(position: .init(x: -350, y: -700), size: .init(width: 150, height: 500), fillColor: .gray)
private let block1 = BounceBlock(position: .init(x: 0, y: -300) , size: CGSize(width: 200, height: 50), fillColor: .green)
private let block2 = BounceBlock(position: .init(x: 0, y: 0) , size: CGSize(width: 200, height: 50), fillColor: .green)
private let path1 = CGPath.init(ellipseIn: CGRect(x: -300/2, y: -300/2, width: 300, height: 300), transform: [CGAffineTransform(scaleX: 1, y: 0.5)])
private let obstacle1 = Obstacle(position: CGPoint(x: 0, y: 0), path: path1)

let level4 = Level(
    fixedPlatform: fixedBlock,
    blocks: [block1],
    obstacles: [obstacle1],
    entryPipe: entryPipe,
    exitPipe: exitPipe
)
