//
//  PlayerControlComponent.swift
//  Rollswhere (ReturnTo-GKEntities)
//
//  Created by Marko on 20/06/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import GameplayKit

class PlayerControlComponent: GKComponent {
    
    var physicsComponent: PhysicsComponent? {
        return entity?.component(ofType: PhysicsComponent.self)
    }
    
    var shapeComponent: ShapeComponent? {
        return entity?.component(ofType: ShapeComponent.self)
    }
    
    var applyingPowerToBall = false
    
    let powerBar = SKShapeNode(rectOf: .init(width: 0, height: 10))
    
    var power: CGFloat = 0
    
    func shoot() {
        if let physicsComponent = physicsComponent {
            physicsComponent.physicsBody?.velocity.dx = power 
        }
    }
    
    func increaseBallPower() {
        power += 50
    }  
    
    func increasePowerBarWidth() {
        powerBar.lineWidth += 1
    }  
    
    func addPowerBar() {
        game.scene?.addChild(powerBar)
    }
    
    func removePowerBar() {
        powerBar.removeFromParent()      
    }
    
    func resetPowerBar() {
        if let shapeNode = shapeComponent?.shapeNode {
            if let boundingBox = shapeNode.path?.boundingBox {
                let radius = (boundingBox.size.width * shapeNode.xScale) / 2
                powerBar.position.x = shapeNode.position.x  
                powerBar.position.y = shapeNode.position.y + radius + 20
                powerBar.strokeColor = .red
                powerBar.lineWidth = 0
                powerBar.zPosition = 10
            }
        }
    }
    
    func returnToStart() {
        power = 0
        physicsComponent?.stopMovement() 
        if let entryPipe = shapeComponent?.shapeNode?.scene?.childNode(withName: "entryPipe") {
            shapeComponent?.shapeNode?.position = entryPipe.position
        }
    }
    
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let selectedNodes = game.scene?.nodes(at: touches.first!.location(in: (game.scene)!))
        applyingPowerToBall = selectedNodes!.first?.name == "ball" && physicsComponent?.physicsBody?.allContactedBodies().count == 1 
    }
        
    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if applyingPowerToBall && power > 0 {
            game.stateMachine.enter(ShootingState.self)
        }
        
        applyingPowerToBall = false
    }
    
    override func update(deltaTime seconds: TimeInterval) {  
        if applyingPowerToBall  {
            increaseBallPower()  
            increasePowerBarWidth()
        }
    }
    
}

