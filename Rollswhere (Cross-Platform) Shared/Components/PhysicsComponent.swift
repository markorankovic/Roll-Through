//
//  PhysicsComponent.swift
//  Rollswhere (ReturnTo-GKEntities)
//
//  Created by Marko on 20/06/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import GameplayKit

class PhysicsComponent: GKComponent {
    
    var geometryComponent: GeometryComponent? {
        return entity?.component(ofType: GeometryComponent.self)   
    }
    
    var physicsBody: SKPhysicsBody?
    
    init(physicsBody: SKPhysicsBody?) {
        super.init()
        self.physicsBody = physicsBody
    } 
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateGeometryComponent() {
        if let geometryComponent = geometryComponent {
            geometryComponent.node?.physicsBody = physicsBody
        }
    }
    
    func activateCollision() {
        physicsBody?.categoryBitMask = 1 
    }
    
    func deactivateCollision() {
        physicsBody?.categoryBitMask = 0 
    }
    
    func stopMovement() {
        physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        physicsBody?.angularVelocity = 0
    }
    
    func setVelocity(velocity: CGVector) {
        physicsBody?.velocity = velocity
    } 
    
    override func update(deltaTime seconds: TimeInterval) {
        updateGeometryComponent()
    }
    
}
