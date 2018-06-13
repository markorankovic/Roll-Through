//
//  GameState.swift
//  Rollswhere (W GameplayKit)
//
//  Created by Marko on 01/06/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import GameplayKit

class GameState: GKState {
    
    weak var scene: GameScene!
        
    init(scene: GameScene) {
        self.scene = scene
    }
    
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { }
    
    func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) { }
    
    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) { }
    
}
 
