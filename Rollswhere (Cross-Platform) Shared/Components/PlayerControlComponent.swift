//
//  PlayerControlComponent.swift
//  Rollswhere (ReturnTo-GKEntities)
//
//  Created by Marko on 20/06/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import GameplayKit

extension CGPoint {
    
    func hypot2(point: CGPoint) -> CGFloat {
        return hypot(self.x - point.x, self.y - point.y)
    }
    
}
 
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
    
    var collidedBlocks: [SKNode] = []
    
    var ballClicked: Bool = false
    
    var ballOverlappingEnabledBlock: Bool = false
    
    var isOverlappingBall: Bool {
        
        if let ballBody = game.entities.filter({ $0.component(ofType: PlayerControlComponent.self) != nil }).first?.component(ofType: PhysicsComponent.self)?.physicsBody {
            let blockEntities = game.entities.filter({ $0.component(ofType: DragComponent.self) != nil })
            for blockEntity in blockEntities {
                if let blockBody = blockEntity.component(ofType: PhysicsComponent.self)?.physicsBody {
                    print("contacted bodies \(ballBody.allContactedBodies())")
                    if ballBody.allContactedBodies().contains(blockBody) && !(blockEntity.component(ofType: DragComponent.self)?.disabled ?? false) {
                        return true
                    }
                }
            }
        }
        
        return false
        
    }

    
    func shoot() {
        if let physicsComponent = physicsComponent {
            physicsComponent.physicsBody?.affectedByGravity = true
            physicsComponent.physicsBody?.applyImpulse(.init(dx: power, dy: 0))
        }
    }
    
    func reactToBounce() {
        if let body = physicsComponent?.physicsBody {
            for contactedBody in body.allContactedBodies() {
                if let node = contactedBody.node {
                    if node.name == "block" && !collidedBlocks.contains(node) {
                        //shrinkBall()
                        //collidedBlocks.append(node)
                    }
                }
            }
        }
    }
    
    func shrinkBall() {
        if let ballNode = geometryComponent?.node {
            ballNode.run(.scale(by: 0.8, duration: 0.3))
        }
    }
    
    func returnToOriginalSize() {
        if let ballNode = geometryComponent?.node {
            ballNode.setScale(1)
        }
    }
    
    func evaluateBallPower(touchLoc: CGPoint) {
        let ballNode = geometryComponent!.node!
        let radius = ballNode.frame.width / 2
        let touchDistanceToBall = touchLoc.hypot2(point: geometryComponent!.node!.position) - radius
        let maxDistance: CGFloat = 300
        power = powerIncrease * touchDistanceToBall / ((maxDistance * powerIncrease) / maxPower)
        if power > maxPower {
            power = maxPower
        }
        //print("power: \(power)")
        if touchDistanceToBall >= 0 {
            evaluatePowerBarLength()
        }
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
            ball.glowWidth = 2.5 
            ball.position = .init(x: radius * cos(angle), y: radius * sin(angle)) 
            powerBar.addChild(ball)
        }
    }
    
    func stopMovement() {
        physicsComponent?.stopMovement()
    }
    
    func addPowerBar() {
        if game.scene?.childNode(withName: "ball")?.childNode(withName: "powerBar")?.parent == nil {
            powerBar.name = "powerBar"
            game.scene?.addChild(powerBar)
        } 
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
    
    func resetBall() {
        power = 0
        geometryComponent?.node?.zRotation = 0
        physicsComponent?.setVelocity(velocity: .init())
        physicsComponent?.physicsBody?.angularVelocity = 0
        returnToOriginalSize()
        collidedBlocks.removeAll()
    } 
    
    func returnToStart() {
        resetBall()
        if let scene = game.scene {
            if let entryPipe = scene.childNode(withName: "entryPipe") {
                if let trigger = entryPipe.childNode(withName: "trigger") {
                    print(entryPipe.position + trigger.position)
                    let squareNode = SKShapeNode(ellipseOf: .init(width: 100, height: 100))
                    squareNode.position = entryPipe.position + trigger.position
                    game.scene?.addChild(squareNode)
                    geometryComponent?.node?.position = entryPipe.position - trigger.position
                }
            }
        }
    }
    
    #if os(iOS)
    
    func panGestureHandler(_ gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let rawLoc = gestureRecognizer.location(in: view)
            let translatedLoc = scene.convertPoint(fromView: rawLoc)
            if game.scene.child(at: translatedLoc).name == geometryComponent.name {
                ballClicked = true
            }
            resetPowerBar()
            addPowerBar()
            return
        } else if gestureRecognizer.state == .ended {
            panGestureEnded()
            return
        }
        evaluateBallShot(gestureRecognizer: gestureRecognizer)
    }
    
    func evaluateBallShot(gestureRecognizer: UIPanGestureRecognizer) {
        guard let scene = game.scene else {
            return
        }
        guard let view = game.scene?.view else {
            return
        }
        let rawLoc = gestureRecognizer.location(in: view)
        let translatedLoc = scene.convertPoint(fromView: rawLoc)
        if let ballNode = geometryComponent?.node {
            if translatedLoc.hypot2(point: ballNode.position) <= ballNode.frame.width/2 && noInvisibleBlock && ballClicked {
                applyingPowerToBall = true
            }
            if applyingPowerToBall {
                evaluateBallPower(touchLoc: translatedLoc)
            }
        }
    }
    
    func panGestureEnded() {
        ballClicked = false
        if applyingPowerToBall && power > 0 {
            game.stateMachine.enter(ShootingState.self)
        }
        removePowerBar()
        applyingPowerToBall = false
    }
    
    #else
    
        func panGestureHandler(_ gestureRecognizer: NSPanGestureRecognizer) {
            if gestureRecognizer.state == .began {
                guard let scene = game.scene else {
                    return
                }
                guard let view = scene.view else {
                    return
                }
                let rawLoc = gestureRecognizer.location(in: view)
                let translatedLoc = scene.convertPoint(fromView: rawLoc)
                if scene.nodes(at: translatedLoc).first?.name == geometryComponent?.node?.name {
                    ballClicked = true
                }
                resetPowerBar()
                addPowerBar()
                return
            } else if gestureRecognizer.state == .ended {
                panGestureEnded()
                return
            }
            evaluateBallShot(gestureRecognizer: gestureRecognizer)
        }
    
        func evaluateBallShot(gestureRecognizer: NSPanGestureRecognizer) {
            guard let scene = game.scene else {
                return
            }
            guard let view = game.scene?.view else {
                return
            }
            let rawLoc = gestureRecognizer.location(in: view)
            let translatedLoc = scene.convertPoint(fromView: rawLoc)
            if let ballNode = geometryComponent?.node {
                if translatedLoc.hypot2(point: ballNode.position) <= ballNode.frame.width/2 && ballClicked && !isOverlappingBall {
                    applyingPowerToBall = true
                }
                if applyingPowerToBall {
                    evaluateBallPower(touchLoc: translatedLoc)
                }
            }
        }
    
        func panGestureEnded() {
            ballClicked = false
            if applyingPowerToBall && power > 0 {
                game.stateMachine.enter(ShootingState.self)
            }
            removePowerBar()
            applyingPowerToBall = false
        }

    #endif
        
}

