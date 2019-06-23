//
//  NSViewController+Children.swift
//  Reddit
//
//  Created by Adam Gastineau on 6/23/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import AppKit

extension NSViewController {
    func add(_ child: NSViewController) {
        addChild(child)
        view.addSubview(child.view)
    }
    
    func remove() {
        guard parent != nil else {
            return
        }
        
        view.removeFromSuperview()
        removeFromParent()
    }
}
