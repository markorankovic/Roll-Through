//
//  Level3.swift
//  Rollswhere (W GameplayKit)
//
//  Created by Marko on 13/06/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import SpriteKit

private let fixedBlock: SKShapeNode = {
    () in let shapeNode = SKShapeNode(rectOf: CGSize(width: 200, height: 50))
    shapeNode.fillColor = .red
    shapeNode.strokeColor = .black
    shapeNode.position = CGPoint(x: 400, y: 0)
    shapeNode.physicsBody = SKPhysicsBody(edgeLoopFrom: shapeNode.path!)
    shapeNode.physicsBody?.pinned = true
    return shapeNode
}()

private let entryPipe: SKShapeNode = {
    () in let shapeNode = SKShapeNode(rectOf: CGSize(width: 150, height: 1000))
    shapeNode.fillColor = .gray
    shapeNode.strokeColor = .black
    shapeNode.position = CGPoint(x: 400, y: 800)
    let body1 = SKPhysicsBody(edgeFrom: CGPoint(x: -75, y: 250), to: CGPoint(x: -75, y: -250))
    let body2 = SKPhysicsBody(edgeFrom: CGPoint(x: 75, y: 250), to: CGPoint(x: 75, y: -250))
    shapeNode.physicsBody = SKPhysicsBody(bodies: [body1, body2])
    shapeNode.physicsBody?.pinned = true
    return shapeNode
}()

private let exitPipe: SKShapeNode = {
    () in let shapeNode = SKShapeNode(rectOf: CGSize(width: 150, height: 1000))
    shapeNode.fillColor = .gray
    shapeNode.strokeColor = .black
    let body1 = SKPhysicsBody(edgeFrom: CGPoint(x: -75, y: 500), to: CGPoint(x: -75, y: -500))
    let body2 = SKPhysicsBody(edgeFrom: CGPoint(x: 75, y: 500), to: CGPoint(x: 75, y: -500))
    shapeNode.physicsBody = SKPhysicsBody(bodies: [body1, body2])
    shapeNode.position = CGPoint(x: -400, y: -200) 
    shapeNode.physicsBody?.pinned = true
    return shapeNode
}()

private let block1: SKShapeNode = {
    () in let shapeNode = SKShapeNode(rectOf: CGSize(width: 200, height: 50))
    shapeNode.fillColor = .green
    shapeNode.strokeColor = .black
    shapeNode.physicsBody = SKPhysicsBody(edgeLoopFrom: shapeNode.path!)
    shapeNode.physicsBody?.affectedByGravity = false
    return shapeNode
}()

private let block2: SKShapeNode = {
    () in let shapeNode = SKShapeNode(rectOf: CGSize(width: 200, height: 50))
    shapeNode.fillColor = .green
    shapeNode.strokeColor = .black
    shapeNode.physicsBody = SKPhysicsBody(edgeLoopFrom: shapeNode.path!)
    shapeNode.physicsBody?.affectedByGravity = false
    return shapeNode
}() 

let level3 = Level(
    fixedPlatform: fixedBlock,
    blocks: [block1, block2],
    obstacles: [],
    entryPipe: entryPipe,
    exitPipe: exitPipe
)
