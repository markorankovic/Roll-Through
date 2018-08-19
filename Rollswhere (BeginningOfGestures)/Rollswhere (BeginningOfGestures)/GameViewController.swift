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
        
        if let skView = view as? SKView {
            let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureHandler(gestureRecognizer:)))
            rightSwipe.direction = .right
            rightSwipe.numberOfTouchesRequired = 2
            let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureHandler(gestureRecognizer:)))
            leftSwipe.direction = .left
            leftSwipe.numberOfTouchesRequired = 2
            let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureHandler(gestureRecognizer:)))
            upSwipe.direction = .up
            upSwipe.numberOfTouchesRequired = 2
            let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureHandler(gestureRecognizer:)))
            downSwipe.direction = .down
            downSwipe.numberOfTouchesRequired = 2
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureHandler(gestureRecognizer:)))
            longPress.numberOfTouchesRequired = 2
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler(gestureRecognizer:)))
            tap.numberOfTouchesRequired = 1
            let rotation = UIRotationGestureRecognizer(target: self, action: #selector(rotationGestureHandler(gestureRecognizer:)))
            let pan = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler(gestureRecognizer:)))
            pan.maximumNumberOfTouches = 1

        
            skView.addGestureRecognizer(rightSwipe)
            skView.addGestureRecognizer(leftSwipe)
            skView.addGestureRecognizer(upSwipe)
            skView.addGestureRecognizer(downSwipe)
            skView.addGestureRecognizer(longPress)
            skView.addGestureRecognizer(tap)
            skView.addGestureRecognizer(rotation)
            skView.addGestureRecognizer(pan)

            
            skView.presentScene(game.scene) 
        }
        
    }
    
    
    
    @IBAction func swipeGestureHandler(gestureRecognizer: UISwipeGestureRecognizer) {
        game.scene?.swipeGestureHandler(gestureRecognizer)
        print("\(gestureRecognizer.direction) gesture detected")
    } 
    
    @IBAction func panGestureHandler(gestureRecognizer: UIPanGestureRecognizer) {
        game.scene?.panGestureHandler(gestureRecognizer)
    }
    
    @IBAction func rotationGestureHandler(gestureRecognizer: UIRotationGestureRecognizer) {
        game.scene?.rotationGestureHandler(gestureRecognizer)
    }
    
    @IBAction func tapGestureHandler(gestureRecognizer: UITapGestureRecognizer) {
        game.scene?.tapGestureHandler(gestureRecognizer)
    }
    
    @IBAction func longPressGestureHandler(gestureRecognizer: UILongPressGestureRecognizer) {
        game.scene?.longPressGestureHandler(gestureRecognizer) 
        print("long press gesture detected")
    }
    
    
    
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return .landscapeLeft
//    }
    
      
}
