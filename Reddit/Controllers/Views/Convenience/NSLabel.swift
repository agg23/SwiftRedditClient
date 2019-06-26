//
//  NSLabel.swift
//  Reddit
//
//  Created by Adam Gastineau on 6/18/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import AppKit

class NSLabel: NSTextField {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        self.isBezeled = false
        self.drawsBackground = false
        self.isEditable = false
        self.isSelectable = false
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NSLabel {
    public func setWrappable() {
        setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        setContentHuggingPriority(.defaultLow, for: .horizontal)
        setContentHuggingPriority(.defaultLow, for: .vertical)
        lineBreakMode = .byWordWrapping
    }
}
