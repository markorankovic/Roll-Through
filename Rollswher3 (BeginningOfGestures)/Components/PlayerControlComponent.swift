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
    
    var geometryComponent: GeometryComponent? {
        return entity?.component(ofType: GeometryComponent.self)
    }
    
    let maxPower: CGFloat = 10000
    
    let powerIncrease: CGFloat = 100
    
    var applyingPowerToBall = false
    
    let powerBar = SKNode()
    
    var power: CGFloat = 0
    
    func shoot() {
        if let physicsComponent = physicsComponent {
            physicsComponent.physicsBody?.velocity.dx = power 
        }  
    }
    
    func evaluateBallPower(touchLoc: CGPoint) {
        let touchDistanceToBall = touchLoc.hypot2(point: geometryComponent!.node!.position)
        let maxDistance: CGFloat = 300
        power = powerIncrease * touchDistanceToBall / ((maxDistance * powerIncrease) / maxPower)
        if power > maxPower {
            power = maxPower
        }
        //print("power: \(power)")
        evaluatePowerBarLength()
    }
    
    func evaluatePowerBarLength() {
        let ballNode = geometryComponent!.node!
        let radius = ballNode.frame.width / 2
        let angleFrom = CGFloat.pi / 2
        let angleTo = angleFrom - (power * (2 * CGFloat.pi)) / maxPower
        powerBar.removeAllChildren()
        createTrail(radius, angleFrom, angleTo)
    }
    
    func createTrail(_ radius: CGFloat, _ angleFrom: CGFloat, _ angleTo: CGFloat) {
        for angle in stride(from: angleFrom, to: angleTo, by: (angleTo - angleFrom) / (2 * radius)) {
            let ball = SKShapeNode(ellipseOf: .init(width: 1, height: 1))
            ball.strokeColor = .red
            ball.fillColor = .red
            ball.glowWidth = 5
            ball.position = .init(x: radius * cos(angle), y: radius * sin(angle)) 
            powerBar.addChild(ball)
        }
    }
    
    func addPowerBar() {
        game.scene?.addChild(powerBar)
    }
    
    func removePowerBar() {
        powerBar.removeFromParent()      
    }
    
    func resetPowerBar() {
        if let shapeNode = geometryComponent?.node {
            powerBar.position.x = shapeNode.position.x
            powerBar.position.y = shapeNode.position.y 
            powerBar.removeAllChildren()
            powerBar.zPosition = 10
        }
    }
    
    func setPlayerVelocity(to: CGVector) {
        physicsComponent?.physicsBody?.velocity = to 
    }
    
    func returnToStart() {
        power = 0
        physicsComponent?.stopMovement() 
        if let entryPipe = geometryComponent?.node?.scene?.childNode(withName: "entryPipe") {
            geometryComponent?.node?.position.x = entryPipe.position.x + 300 * cos(entryPipe.zRotation + CGFloat.pi / 2)
            geometryComponent?.node?.position.y = entryPipe.position.y + 300 * sin(entryPipe.zRotation + CGFloat.pi / 2)
        }
    }
    
    func panGestureHandler(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let scene = game.scene else {
            return
        }
        guard let view = game.scene?.view else {
            return
        }
        if gestureRecognizer.state == .ended {
            panGestureEnded()
            return
        }
        let rawLoc = gestureRecognizer.location(in: view)
        let translatedLoc = scene.convertPoint(fromView: rawLoc)
        let contactedNodes = scene.nodes(at: translatedLoc)
        if let ballNode = (contactedNodes.first?.name == "ball") ? contactedNodes.first : nil {
            if ballNode.physicsBody?.allContactedBodies().count == 1 {
                applyingPowerToBall = true
            }
        }
        if applyingPowerToBall {
            evaluateBallPower(touchLoc: translatedLoc)
        }
    } 
    
    func panGestureEnded() { 
        if applyingPowerToBall && power > 0 {
            game.stateMachine.enter(ShootingState.self)
        }
        applyingPowerToBall = false
    }
    
}

