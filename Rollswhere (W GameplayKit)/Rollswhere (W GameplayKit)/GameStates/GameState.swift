//
//  GameState.swift
//  Rollswhere (W GameplayKit)
//
//  Created by Marko on 01/06/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import GameplayKit

class GameState: GKState {
        
    var ball: Ball? {
        return game.entities.first(where: { $0 is Ball }) as? Ball
    }
    
//    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { }
//
//    func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) { }
//
//    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) { }
    
}


 
