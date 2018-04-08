//
//  GameViewController.swift
//  Rollswhere
//
//  Created by Marko on 08/04/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            let scene = GameScene()
            // Set the scale mode to scale to fit the window
            scene.size = view.bounds.size
            scene.scaleMode = .aspectFill
            scene.anchorPoint = .init(x: 0.5, y: 0.5)
            scene.physicsBody = SKPhysicsBody(edgeLoopFrom: scene.frame)
            // Present the scene
            view.presentScene(scene)
        }
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
