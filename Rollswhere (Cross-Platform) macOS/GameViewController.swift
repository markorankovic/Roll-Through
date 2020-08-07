//
//  GameViewController.swift
//  Rollswhere (Cross-Platform) macOS
//
//  Created by Marko on 14/12/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class GameViewController: NSViewController {

    override func viewDidLoad() {
        print("View loaded")
        
        if let skView = view as? SKView {
            //skView.showsPhysics = true
            
            let longPress = NSPressGestureRecognizer(target: self, action: #selector(longPressGestureHandler(gestureRecognizer:)))
            longPress.numberOfTouchesRequired = 2
            
            let tap1 = NSClickGestureRecognizer(target: self, action: #selector(tapGestureHandler(gestureRecognizer:)))
            tap1.numberOfTouchesRequired = 1
            
            let tap2 = NSClickGestureRecognizer(target: self, action: #selector(tapGestureHandler(gestureRecognizer:)))
            tap2.numberOfTouchesRequired = 2
            
            let rotation = NSRotationGestureRecognizer(target: self, action: #selector(rotationGestureHandler(gestureRecognizer:)))
            
            let pan = NSPanGestureRecognizer(target: self, action: #selector(panGestureHandler(gestureRecognizer:)))
            
            skView.addGestureRecognizer(longPress)
            skView.addGestureRecognizer(tap1)
            skView.addGestureRecognizer(tap2)
            skView.addGestureRecognizer(rotation)
            skView.addGestureRecognizer(pan)
            
            game.returnToMainMenu(view: skView)
        }
        
    }
    
    override func scrollWheel(with event: NSEvent) {
        ((view as? SKView)?.scene as? GestureHandler)?.scrollHandler(with: event)
    }
    
    @IBAction func panGestureHandler(gestureRecognizer: NSPanGestureRecognizer) {
        ((view as? SKView)?.scene as? GestureHandler)?.panGestureHandler(gestureRecognizer: gestureRecognizer)
    }
    
    @IBAction func rotationGestureHandler(gestureRecognizer: NSRotationGestureRecognizer) {
        ((view as? SKView)?.scene as? GestureHandler)?.rotationGestureHandler(gestureRecognizer: gestureRecognizer)
    }
    
    @IBAction func tapGestureHandler(gestureRecognizer: NSClickGestureRecognizer) {
        ((view as? SKView)?.scene as? GestureHandler)?.tapGestureHandler(gestureRecognizer: gestureRecognizer)
    }
    
    @IBAction func longPressGestureHandler(gestureRecognizer: NSPressGestureRecognizer) {
        ((view as? SKView)?.scene as? GestureHandler)?.longPressGestureHandler(gestureRecognizer: gestureRecognizer)
        print("long press gesture detected")
    }

}

