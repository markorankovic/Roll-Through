//
//  GestureHandler.swift
//  Rollswhere (Cross-Platform) Shared
//
//  Created by Marko on 14/12/2018.
//  Copyright © 2018 Marko. All rights reserved.
//

#if os(iOS)

import UIKit

protocol GestureHandler {
    
    func swipeGestureHandler(_ gestureRecognizer: UISwipeGestureRecognizer)

    func panGestureHandler(_ gestureRecognizer: UIPanGestureRecognizer)

    func tapGestureHandler(_ gestureRecognizer: UITapGestureRecognizer)

    func longPressGestureHandler(_ gestureRecognizer: UILongPressGestureRecognizer)

    func rotationGestureHandler(_ gestureRecognizer: UIRotationGestureRecognizer)
    
}

#else

import Cocoa

protocol GestureHandler {

    func panGestureHandler(gestureRecognizer: NSPanGestureRecognizer)

    func rotationGestureHandler(gestureRecognizer: NSRotationGestureRecognizer)

    func tapGestureHandler(gestureRecognizer: NSClickGestureRecognizer)

    func longPressGestureHandler(gestureRecognizer: NSPressGestureRecognizer)
    
    func scrollHandler(with event: NSEvent)

}

#endif
