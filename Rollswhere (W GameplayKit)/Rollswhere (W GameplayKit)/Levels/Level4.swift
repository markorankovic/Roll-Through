//
//  Level4.swift
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
    () in let shapeNode = SKShapeNode(rectOf: CGSize(width: 150, height: 500))
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
    shapeNode.position = CGPoint(x: -350, y: -700)
    shapeNode.physicsBody?.pinned = true
    return shapeNode  
}()

private let block1: SKShapeNode = {
    () in let shapeNode = SKShapeNode(rectOf: CGSize(width: 200, height: 50))
    shapeNode.fillColor = .green
    shapeNode.strokeColor = .black
    shapeNode.position = CGPoint(x: 0, y: -300)
    shapeNode.physicsBody = SKPhysicsBody(edgeLoopFrom: shapeNode.path!)
    shapeNode.physicsBody?.affectedByGravity = false
    return shapeNode
}()
 
private let obstacle1: SKShapeNode = {
    () in let path1 = CGPath.init(ellipseIn: CGRect(x: -300/2, y: -300/2, width: 300, height: 300), transform: [CGAffineTransform(scaleX: 1, y: 0.5)])
    let shapeNode = SKShapeNode()
    shapeNode.path = path1
    shapeNode.strokeColor = .black
    shapeNode.fillColor = .red
    shapeNode.physicsBody = SKPhysicsBody(edgeChainFrom: path1)
    return shapeNode
}()

let level4 = Level(
    fixedPlatform: fixedBlock,
    blocks: [block1],
    obstacles: [obstacle1],
    entryPipe: entryPipe,
    exitPipe: exitPipe
)
