//
//  EnitityManager.swift
//  Rollswhere (W GameplayKit)
//
//  Created by Marko on 01/06/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import GameplayKit

class EnitityManager {
    
    var entities = Set<GKEntity>()
    weak var scene: GameScene!
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    func add(entity: GKEntity) {
        entities.insert(entity)
        if let shape = entity.component(ofType: ShapeComponent.self)?.shapeNode {
            scene.addChild(shape)
        }
    }
    
    func remove(entity: GKEntity) {
        entities.remove(entity)
        if let shape = entity.component(ofType: ShapeComponent.self)?.shapeNode {
            shape.removeFromParent()
        }
    }
    
} 

