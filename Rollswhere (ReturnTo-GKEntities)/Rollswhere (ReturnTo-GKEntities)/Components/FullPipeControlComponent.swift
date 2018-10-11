//
//  FullPipeControlComponent.swift
//  Rollswhere (ReturnTo-GKEntities)
//
//  Created by Marko on 03/07/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import GameplayKit

class FullPipeControlComponent: GKComponent {
    
    var geometryComponent: GeometryComponent? {
        return entity?.component(ofType: GeometryComponent.self)
    }
    
    func handleObjectInFullPipe(_ object: SKNode, _ quarterPipe1: SKNode, _ quarterPipe2: SKNode, _ quarterPipe3: SKNode, _ quarterPipe4: SKNode) {
        //print("handleObjectInFullPipe")
        if let objectBody = object.physicsBody {
            //print(quarterPipe3.physicsBody!.allContactedBodies())
            if let hitThirdPipe = quarterPipe3.physicsBody?.allContactedBodies().contains(objectBody) {
                if let hitSecondPipe = quarterPipe2.physicsBody?.allContactedBodies().contains(objectBody) {
                    if hitSecondPipe {
                        //print("Second pipe hit")
                        quarterPipe1.physicsBody?.categoryBitMask = objectBody.collisionBitMask
                        quarterPipe4.physicsBody?.categoryBitMask = 0
                        quarterPipe1.zPosition = object.zPosition - 1
                        quarterPipe4.zPosition = object.zPosition + 1
//                        quarterPipe4.run(.move(to: .init(x: 136.035, y: -108.561), duration: 0.1))
//                        quarterPipe1.run(.move(to: .init(x: 69.746, y: -208.561), duration: 0.1))
                    }
                    if hitThirdPipe {
                        //print("Third pipe hit")
                        quarterPipe1.physicsBody?.categoryBitMask = 0
                        quarterPipe4.physicsBody?.categoryBitMask = objectBody.collisionBitMask
                        quarterPipe1.zPosition = object.zPosition + 1
                        quarterPipe4.zPosition = object.zPosition - 1
//                        quarterPipe1.run(.move(to: .init(x: 69.746, y: -108.561), duration: 0.1))
//                        quarterPipe4.run(.move(to: .init(x: 136.035, y: -208.561), duration: 0.1))
                    }
                } 
            }
        }
    }
    
    func handleObjectOutsideFullPipe(_ object: SKNode, _ quarterPipe1: SKNode, _ quarterPipe2: SKNode, _ quarterPipe3: SKNode, _ quarterPipe4: SKNode) { 
        //print("handleObjectOutsideFullPipe")
         if let objectBody = object.physicsBody {
            if objectBody.velocity.dx > 0 {
                quarterPipe1.physicsBody?.categoryBitMask = objectBody.collisionBitMask
                quarterPipe4.physicsBody?.categoryBitMask = 0
                quarterPipe4.zPosition = object.zPosition + 1
                quarterPipe1.zPosition = object.zPosition - 1
//                quarterPipe4.run(.move(to: .init(x: 136.035, y: -108.561), duration: 0.1))
//                quarterPipe1.run(.move(to: .init(x: 69.746, y: -208.561), duration: 0.1))
            } else if objectBody.velocity.dx < 0 {
                quarterPipe1.physicsBody?.categoryBitMask = 0
                quarterPipe4.physicsBody?.categoryBitMask = objectBody.collisionBitMask
                quarterPipe1.zPosition = object.zPosition + 1
                quarterPipe4.zPosition = object.zPosition - 1
//                quarterPipe1.run(.move(to: .init(x: 69.746, y: -108.561), duration: 0.1))
//                quarterPipe4.run(.move(to: .init(x: 136.035, y: -208.561), duration: 0.1))
            } 
        }
    }
    
    func handleFullPipe(object: SKNode, quarterPipe1: SKNode, quarterPipe2: SKNode, quarterPipe3: SKNode, quarterPipe4: SKNode) {
        let fullPipeFrame = geometryComponent!.node!.calculateAccumulatedFrame()
        let ballInFullPipe = fullPipeFrame.intersects(object.frame) 
        //print("Ball frame: \(object.frame)")
        if ballInFullPipe {
            handleObjectInFullPipe(object, quarterPipe1, quarterPipe2, quarterPipe3, quarterPipe4)
        } else {
            handleObjectOutsideFullPipe(object, quarterPipe1, quarterPipe2, quarterPipe3, quarterPipe4) 
        }
    }
    
    func reactToObject(object: SKNode) { 
        if let firstQuarterPipe = geometryComponent?.node?.childNode(withName: "quarterPipe1") {
            if let lastQuarterPipe = geometryComponent?.node?.childNode(withName: "quarterPipe4") {
                if let thirdQuarterPipe = geometryComponent?.node?.childNode(withName: "quarterPipe3") {
                    if let secondQuarterPipe = geometryComponent?.node?.childNode(withName: "quarterPipe2") {
                        handleFullPipe(object: object, quarterPipe1: firstQuarterPipe, quarterPipe2: secondQuarterPipe, quarterPipe3: thirdQuarterPipe, quarterPipe4: lastQuarterPipe)
                    }
                }
            }
        }
    }
    
}
