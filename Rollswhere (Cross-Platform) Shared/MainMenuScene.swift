//
//  MainMenuScene.swift
//  Rollswhere (Cross-Platform) Shared
//
//  Created by Marko on 14/12/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import SpriteKit

#if os(iOS)

class MainMenuScene: SKScene, GestureHandler {  }

extension MainMenuScene {
    
    func swipeGestureHandler(_ gestureRecognizer: UISwipeGestureRecognizer) {
        
    }
    
    func panGestureHandler(_ gestureRecognizer: UIPanGestureRecognizer) {
        
    }
    
    func longPressGestureHandler(_ gestureRecognizer: UILongPressGestureRecognizer) {
        
    }
    
    func rotationGestureHandler(_ gestureRecognizer: UIRotationGestureRecognizer) {
        
    }
    
    func tapGestureHandler(_ gestureRecognizer: UITapGestureRecognizer) {
        view?.presentScene(LevelSelectionScene(fileNamed: "LevelSelectionScene.sks"))
    }
    
}

#else

class MainMenuScene: SKScene, GestureHandler {
    
    func scrollHandler(with event: NSEvent) {
    }
    
    
    func panGestureHandler(gestureRecognizer: NSPanGestureRecognizer) {
        
    }
    
    func rotationGestureHandler(gestureRecognizer: NSRotationGestureRecognizer) {
        
    }
    
    func tapGestureHandler(gestureRecognizer: NSClickGestureRecognizer) {
        view?.presentScene(LevelSelectionScene(fileNamed: "LevelSelectionScene.sks"))
    }
    
    func longPressGestureHandler(gestureRecognizer: NSPressGestureRecognizer) {
        
    }
    
    
    override func mouseUp(with event: NSEvent) {
        view?.presentScene(LevelSelectionScene(fileNamed: "LevelSelectionScene.sks"))
    }
        
}

#endif

extension MainMenuScene {
    
    override func didMove(to view: SKView) {
        print(3)
        adaptRollswhereLogo()
        adaptStartLabel()
        evaluateStartLabelOnOS()
    }
    
    func adaptRollswhereLogo() {
        if let logo = childNode(withName: "logo") as? SKSpriteNode {
            let widthPercent: CGFloat = 1274 / 1920
            let heightPercent: CGFloat = 350 / 1920
            let logoYPosPercent: CGFloat = 320 / (1920 / 2)
            logo.scale(to: CGSize(width: size.width * widthPercent, height: size.height * heightPercent))
            logo.position.y = (size.height / 2) * logoYPosPercent
        }
    }
    
    func adaptStartLabel() {
        if let startLabel = childNode(withName: "instructionLabel") as? SKLabelNode {
            let heightPercent: CGFloat = 54 / 1080
            let startLabelYPosPercent: CGFloat = -360 / (1080 / 2)
            startLabel.fontSize = size.height * heightPercent
            startLabel.position.y = (size.height / 2) * startLabelYPosPercent
        }
    }
    
    func evaluateStartLabelOnOS() {
        #if os(OSX)
            if let startLabel = childNode(withName: "instructionLabel") as? SKLabelNode {
                startLabel.text = "Click To Start"
            }
        #endif
    }
    
}

