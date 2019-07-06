//
//  GestureHandler.swift
//  Rollswhere (BeginningOfGestures)
//
//  Created by Marko on 01/09/2018.
//  Copyright © 2018 Marko. All rights reserved.
//
   
import UIKit

protocol GestureHandler {
    
    func swipeGestureHandler(_ gestureRecognizer: UISwipeGestureRecognizer)
    
    func panGestureHandler(_ gestureRecognizer: UIPanGestureRecognizer)
    
    func tapGestureHandler(_ gestureRecognizer: UITapGestureRecognizer)
    
    func longPressGestureHandler(_ gestureRecognizer: UILongPressGestureRecognizer)
    
    func rotationGestureHandler(_ gestureRecognizer: UIRotationGestureRecognizer)
    
}
