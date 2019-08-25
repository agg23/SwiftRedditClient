//
//  SegmentedToolbar.swift
//  Reddit
//
//  Created by Adam Gastineau on 8/25/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import Cocoa

class SegmentedToolbar: NSToolbarItemGroup {
    let segmentedControl = NSSegmentedControl()
    
    override init(itemIdentifier: NSToolbarItem.Identifier) {
        super.init(itemIdentifier: itemIdentifier)
    }
    
    convenience init(itemIdentifier: NSToolbarItem.Identifier, items: [NSToolbarItem]) {
        self.init(itemIdentifier: itemIdentifier)
        
        subitems = items
        
        segmentedControl.segmentStyle = .texturedSquare
        segmentedControl.trackingMode = .momentary
        segmentedControl.segmentCount = items.count
        segmentedControl.focusRingType = .none
        
        segmentedControl.action = #selector(clickSegment(_:))
        segmentedControl.target = self
        
        for (index, item) in items.enumerated() {
            segmentedControl.setImage(item.image, forSegment: index)
            segmentedControl.setImageScaling(.scaleProportionallyDown, forSegment: index)
        }
        
        view = segmentedControl
    }
    
    @objc func clickSegment(_ sender: NSSegmentedControl) {
        guard sender.indexOfSelectedItem < subitems.count else {
            return
        }
        
        let item = subitems[sender.indexOfSelectedItem]
        if let action = item.action {
            NSApp.sendAction(action, to: item.target, from: item)
        }
    }
}
