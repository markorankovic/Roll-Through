//
//  LevelSelectionScene.swift
//  Rollswhere (Cross-Platform) Shared
//
//  Created by Marko on 14/12/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import SpriteKit

#if os(iOS)

class LevelSelectionScene: SKScene, GestureHandler {  }

extension LevelSelectionScene {
    
    func swipeGestureHandler(_ gestureRecognizer: UISwipeGestureRecognizer) {
        print(gestureRecognizer.numberOfTouches)
        if gestureRecognizer.direction == .left {
            attemptToMoveEndToOtherEnd(.right)
            shiftLevel(.right)
        } else if gestureRecognizer.direction == .right {
            attemptToMoveEndToOtherEnd(.left)
            shiftLevel(.left)
        }
    }
    
    func tapGestureHandler(_ gestureRecognizer: UITapGestureRecognizer) {
        if nodes(at: convertPoint(fromView: gestureRecognizer.location(in: view))).filter({ $0.name == "backButtonLabel" }).count > 0 {
            view?.presentScene(MainMenuScene(fileNamed: "MainMenuScene.sks"))
            return
        }
        guard let middleScreenshot = nodes(at: .init()).filter({ $0.name == "levelScreenshot" }).first else {
            return
        }
        guard let levelNumberText = (middleScreenshot.childNode(withName: "levelNumberLabel") as? SKLabelNode)?.text else {
            return
        }
        guard let levelNumber = Int(levelNumberText) else {
            return
        }
        if let view = view {
            if nodes(at: convertPoint(fromView: gestureRecognizer.location(in: view))).filter({ $0.name == "levelScreenshot" }).first == middleScreenshot {
                game.loadLevel(view: view, levelNumber: levelNumber)
            }
        }
    }
    
    func panGestureHandler(_ gestureRecognizer: UIPanGestureRecognizer) {
    }
    
    func longPressGestureHandler(_ gestureRecognizer: UILongPressGestureRecognizer) {
    }
    
    func rotationGestureHandler(_ gestureRecognizer: UIRotationGestureRecognizer) {
    }
    
}

#else

class LevelSelectionScene: SKScene, GestureHandler {
    
    func panGestureHandler(gestureRecognizer: NSPanGestureRecognizer) {
        
    }
    
    func rotationGestureHandler(gestureRecognizer: NSRotationGestureRecognizer) {
        
    }
    
    func tapGestureHandler(gestureRecognizer: NSClickGestureRecognizer) {
        
        if nodes(at: convertPoint(fromView: gestureRecognizer.location(in: view))).filter({ $0.name == "backButtonLabel" }).count > 0 {
            view?.presentScene(MainMenuScene(fileNamed: "MainMenuScene.sks"))
            return
        }
        guard let middleScreenshot = nodes(at: .init()).filter({ $0.name == "levelScreenshot" }).first else {
            return
        }
        guard let levelNumberText = (middleScreenshot.childNode(withName: "levelNumberLabel") as? SKLabelNode)?.text else {
            return
        }
        guard let levelNumber = Int(levelNumberText) else {
            return
        }
        if let view = view {
            if nodes(at: convertPoint(fromView: gestureRecognizer.location(in: view))).filter({ $0.name == "levelScreenshot" }).first == middleScreenshot {
                game.loadLevel(view: view, levelNumber: levelNumber)
            }
        }

    }
    
    func longPressGestureHandler(gestureRecognizer: NSPressGestureRecognizer) {
        
    }
    
    func scrollHandler(with event: NSEvent) {
        if event.deltaX > 0 {
            attemptToMoveEndToOtherEnd(.right)
            shiftLevel(.right)
        } else if event.deltaX < 0 {
            attemptToMoveEndToOtherEnd(.left)
            shiftLevel(.left)
        }
    }
    
}

#endif

extension LevelSelectionScene {
    
    override func didMove(to view: SKView) {
        addLevelScreenShots()
        fitLevelScreenShots()
        spaceLevelScreenShots()
        fitLevelSelectionAndLevelNumberLabel()
        fitBackButtonLabel(view)
    }
    
    func fitBackButtonLabel(_ view: SKView) {
        if let backButtonLabel = childNode(withName: "backButtonLabel") as? SKLabelNode {
            if let levelScreenshotHeight = getLevelScreenShotDimensions()?.height {
                let fontSize = (size.height - levelScreenshotHeight) / 4
                backButtonLabel.fontSize = fontSize
                backButtonLabel.position.y = -view.frame.size.height/2
            }
        }
    }
    
    func getLevelScreenShotDimensions() -> CGSize? {
        if let levelScreenshotGallery = childNode(withName: "levelScreenshotGallery") {
            if let levelScreenshot = levelScreenshotGallery.children.first {
                return levelScreenshot.frame.size
            }
        }
        return nil
    }
    
    func fitLevelScreenShots() {
        if let levelScreenshotGallery = childNode(withName: "levelScreenshotGallery") {
            for levelScreenshot in levelScreenshotGallery.children {
                levelScreenshot.xScale *= (size.width / levelScreenshot.frame.width) * 0.8
                levelScreenshot.yScale *= (size.height / levelScreenshot.frame.height) * 0.8
            }
        }
    }
    
    func fitLevelSelectionAndLevelNumberLabel() {
        if let levelScreenshotHeight = getLevelScreenShotDimensions()?.height {
            let fontSize = size.height / 2 - levelScreenshotHeight / 2
            if let levelSelectionLabel = childNode(withName: "levelSelectionLabel") as? SKLabelNode {
                levelSelectionLabel.fontSize = fontSize
                levelSelectionLabel.position.y = size.height / 2 - fontSize
                if let levelScreenshotGallery = childNode(withName: "levelScreenshotGallery") {
                    for levelScreenshot in levelScreenshotGallery.children {
                        if let levelNumberLabel = levelScreenshot.childNode(withName: "levelNumberLabel") as? SKLabelNode {
                            levelNumberLabel.fontSize = fontSize * 2
                        }
                    }
                }
            }
        }
    }
    
    func addLevelScreenShots() {
        let numberOfExistingLevels = game.numberOfLevels
        let levelScreenshotGallery = SKNode()
        levelScreenshotGallery.name = "levelScreenshotGallery"
        addChild(levelScreenshotGallery)
        for i in 1...numberOfExistingLevels {
            let levelScreenShot = SKSpriteNode(color: .black, size: size)
            levelScreenShot.name = "levelScreenshot"
            let levelNumberLabel = SKLabelNode(text: "\(i)")
            levelNumberLabel.name = "levelNumberLabel"
            levelScreenShot.addChild(levelNumberLabel)
            levelScreenshotGallery.addChild(levelScreenShot)
        }
    }
    
    func spaceLevelScreenShots() {
        if let levelScreenshotGallery = childNode(withName: "levelScreenshotGallery") {
            let levelScreenshotWidth = levelScreenshotGallery.calculateAccumulatedFrame().width
            let spacing = levelScreenshotWidth / 8
            for (i, levelScreenshot) in levelScreenshotGallery.children.enumerated() {
                levelScreenshot.position.x += CGFloat(i) * (spacing + levelScreenshotWidth)
            }
        }
    }
    
    enum Direction {
        case left
        case right
    }
    
    func getEndingLevelScreenshot(end: Direction) -> SKNode? {
        guard let levelScreenshotGallery = childNode(withName: "levelScreenshotGallery") else {
            return nil
        }
        if end == .left {
            return levelScreenshotGallery.children.sorted(by: { $0.position.x < $1.position.x }).first
        }
        return levelScreenshotGallery.children.sorted(by: { $0.position.x > $1.position.x }).first
    }
    
    func moveEndingScreenshotToOtherEnd(end: Direction) {
        guard let levelScreenshotWidth = childNode(withName: "levelScreenshotGallery")?.children.first?.frame.width else {
            return
        }
        guard let rightEnd = getEndingLevelScreenshot(end: .right) else {
            return
        }
        guard let leftEnd = getEndingLevelScreenshot(end: .left) else {
            return
        }
        let spacing = levelScreenshotWidth / 8
        if end == .left {
            leftEnd.position.x = rightEnd.position.x + levelScreenshotWidth + spacing
        } else {
            rightEnd.position.x = leftEnd.position.x - levelScreenshotWidth - spacing
        }
    }
    
    func attemptToMoveEndToOtherEnd(_ direction: Direction) {
        guard let middleScreenshot = nodes(at: .init()).filter({ $0.name == "levelScreenshot" }).first else {
            return
        }
        let atLeftEnd = middleScreenshot == getEndingLevelScreenshot(end: .left)
        let atRightEnd = middleScreenshot == getEndingLevelScreenshot(end: .right)
        
        if atLeftEnd || atRightEnd {
            if atLeftEnd && direction == .left {
                moveEndingScreenshotToOtherEnd(end: .right)
            } else if atRightEnd && direction == .right {
                moveEndingScreenshotToOtherEnd(end: .left)
            }
        }
    }
    
    func shiftLevel(_ direction: Direction) {
        if let levelScreenshotGallery = childNode(withName: "levelScreenshotGallery") {
            guard !levelScreenshotGallery.hasActions() else {
                return
            }
            print(15)
            guard let levelScreenshotWidth = levelScreenshotGallery.children.first?.frame.width else {
                return
            }
            let spacing = levelScreenshotWidth / 8
            print("shifting by: \(direction)")
            if direction == .right {
                levelScreenshotGallery.run(.moveBy(x: -(levelScreenshotWidth + spacing), y: 0, duration: 0.3))
            } else if direction == .left {
                levelScreenshotGallery.run(.moveBy(x: (levelScreenshotWidth + spacing), y: 0, duration: 0.3))
            }
        }
    }
    
}
