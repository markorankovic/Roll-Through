//
//  GameScene.swift
//  PortalWarpAnimationTest
//
//  Created by Marko on 18/10/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let sourcePositions: [float2] = [
        float2(0, 0), float2(0.33, 0), float2(0.66, 0), float2(1, 0),
        float2(0, 0.33), float2(0.33, 0.33), float2(0.66, 0.33), float2(1, 0.33),
        float2(0, 0.66), float2(0.33, 0.66), float2(0.66, 0.66), float2(1, 0.66),
        float2(0, 1), float2(0.33, 1), float2(0.66, 1), float2(1, 1)
    ]
    let rightDest: [float2] = [
        float2(-0.1, 0.1), float2(0.23, 0.1), float2(0.56, 0.1), float2(0.9, 0.1),
        float2(0.1, 0.33), float2(0.43, 0.43), float2(0.76, 0.43), float2(1.1, 0.33),
        float2(0.1, 0.66), float2(0.43, 0.66), float2(0.76, 0.66), float2(1.1, 0.66),
        float2(0.1, 0.9), float2(0.43, 0.9), float2(0.76, 0.9), float2(1.1, 0.9)
    ]
    let leftDest: [float2] = [
        float2(0.1, -0.1), float2(0.43, -0.1), float2(0.66, -0.1), float2(1.1, -0.1),
        float2(-0.1, 0.33), float2(0.23, 0.23), float2(0.56, 0.23), float2(0.9, 0.33),
        float2(-0.1, 0.66), float2(0.23, 0.66), float2(0.56, 0.66), float2(0.9, 0.66),
        float2(-0.1, 1.1), float2(0.23, 1.1), float2(0.56, 1.1), float2(0.9, 1.1)
    ]
    
    override func didMove(to view: SKView) {

        let rightWarpGrid = SKWarpGeometryGrid(columns: 3, rows: 3, sourcePositions: sourcePositions, destinationPositions: rightDest)
        let leftWarpGrid = SKWarpGeometryGrid(columns: 3, rows: 3, sourcePositions: sourcePositions, destinationPositions: leftDest)
        
        let warpGrids = [rightWarpGrid, leftWarpGrid]

        guard let portal = childNode(withName: "portal") as? SKSpriteNode else {
            print("Portal not found")
            return
        }
        
        portal.removeAllActions()
        
        portal.warpGeometry = SKWarpGeometryGrid(columns: 3, rows: 3)
        
        if let warpAction = SKAction.animate(withWarps: warpGrids, times: [0.4, 0.8]) {
            portal.run(.repeatForever(warpAction))
        }
        
    }
    
}
