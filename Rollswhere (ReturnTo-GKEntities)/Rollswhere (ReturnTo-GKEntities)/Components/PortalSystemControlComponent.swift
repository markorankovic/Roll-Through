//
//  PortalSystemControlComponent.swift
//  Rollswhere (ReturnTo-GKEntities)
//
//  Created by Marko on 25/07/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

import GameplayKit

class PortalSystemControlComponent: GKComponent {
    
    var geometryComponent: GeometryComponent? {
        return entity?.component(ofType: GeometryComponent.self)
    }
    
    func reactToObject(object: SKNode) {
        if let objectBody = object.physicsBody {
            if let portalSystem = geometryComponent?.node {
                if let entryBody = portalSystem.childNode(withName: "entryPortal")?.physicsBody {
                    if let exit = portalSystem.childNode(withName: "exitPortal") {
                        if entryBody.allContactedBodies().contains(objectBody) {
                            object.position = CGPoint(x: portalSystem.position.x + exit.position.x, y: portalSystem.position.y + exit.position.y)
                        }
                    } 
                }
            } 
        }
    }
    
}
