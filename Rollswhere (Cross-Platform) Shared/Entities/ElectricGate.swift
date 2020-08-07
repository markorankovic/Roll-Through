//
//  ElectricGate.swift
//  Rollswhere (ReturnTo-GKEntities)
//
//  Created by Marko on 26/07/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import GameplayKit

class ElectricGate: GKEntity {
    
    override init() {
        super.init()
    }
    
    convenience init(node: SKNode) {
        self.init()
        node.childNode(withName: "button")?.physicsBody?.contactTestBitMask = gateButtonContactCategory
        node.childNode(withName: "gate")?.physicsBody?.categoryBitMask = ballCategory
        addComponent(GeometryComponent(node: node))
        addComponent(ElectricGateControlComponent(originalGatePosition: node.childNode(withName: "gate")?.position)) 
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    } 
    
}
