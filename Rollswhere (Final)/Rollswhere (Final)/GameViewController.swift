//
//  GameViewController.swift
//  Rollswhere (BeginningOfGestures)
//
//  Created by Marko on 15/08/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        print("View loaded")
        
        if let skView = view as? SKView {
            //skView.showsPhysics = true
            
            let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureHandler(gestureRecognizer:)))
            rightSwipe.numberOfTouchesRequired = 2
            rightSwipe.direction = .right
            let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureHandler(gestureRecognizer:)))
            leftSwipe.numberOfTouchesRequired = 2
            leftSwipe.direction = .left
            let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureHandler(gestureRecognizer:)))
            upSwipe.numberOfTouchesRequired = 2
            upSwipe.direction = .up
            let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureHandler(gestureRecognizer:)))
            downSwipe.numberOfTouchesRequired = 2
            downSwipe.direction = .down
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureHandler(gestureRecognizer:)))
            longPress.numberOfTouchesRequired = 2
            
            let tap1 = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler(gestureRecognizer:)))
            tap1.numberOfTouchesRequired = 1
            
            let tap2 = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler(gestureRecognizer:)))
            tap2.numberOfTouchesRequired = 2
            
            let rotation = UIRotationGestureRecognizer(target: self, action: #selector(rotationGestureHandler(gestureRecognizer:)))
            
            let pan = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler(gestureRecognizer:)))
            pan.maximumNumberOfTouches = 1
            
            
            skView.addGestureRecognizer(rightSwipe)
            skView.addGestureRecognizer(leftSwipe)
            skView.addGestureRecognizer(upSwipe)
            skView.addGestureRecognizer(downSwipe)
            skView.addGestureRecognizer(longPress)
            skView.addGestureRecognizer(tap1)
            skView.addGestureRecognizer(tap2)
            skView.addGestureRecognizer(rotation)
            skView.addGestureRecognizer(pan)
            
            print(2)
            skView.presentScene(MainMenuScene(fileNamed: "MainMenuScene.sks"))
            //game.returnToMainMenu(view: skView)
        }
        
    }
    
    
    
    @IBAction func swipeGestureHandler(gestureRecognizer: UISwipeGestureRecognizer) {
        ((view as? SKView)?.scene as? GestureHandler)?.swipeGestureHandler(gestureRecognizer)
        print("\(gestureRecognizer.direction) gesture detected")
    }
    
    @IBAction func panGestureHandler(gestureRecognizer: UIPanGestureRecognizer) {
        ((view as? SKView)?.scene as? GestureHandler)?.panGestureHandler(gestureRecognizer)
    }
    
    @IBAction func rotationGestureHandler(gestureRecognizer: UIRotationGestureRecognizer) {
        ((view as? SKView)?.scene as? GestureHandler)?.rotationGestureHandler(gestureRecognizer)
    }
    
    @IBAction func tapGestureHandler(gestureRecognizer: UITapGestureRecognizer) {
        ((view as? SKView)?.scene as? GestureHandler)?.tapGestureHandler(gestureRecognizer)
    }
    
    @IBAction func longPressGestureHandler(gestureRecognizer: UILongPressGestureRecognizer) {
        ((view as? SKView)?.scene as? GestureHandler)?.longPressGestureHandler(gestureRecognizer)
        print("long press gesture detected")
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    
}

