//
//  MainMenuScene.swift
//  Rollswhere (BeginningOfGestures)
//
//  Created by Marko on 04/09/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import SpriteKit

class MainMenuScene: SKScene, GestureHandler {
    
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
    
    override func didMove(to view: SKView) {
        print(3)
        adaptRollswhereLogo()
        adaptStartLabel()
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

}
