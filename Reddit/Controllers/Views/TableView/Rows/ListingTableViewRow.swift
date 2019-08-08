//
//  ListingTableViewRow.swift
//  Reddit
//
//  Created by Adam Gastineau on 6/22/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import AppKit

class ListingTableViewRow<T>: NSView {
    internal var _data: T? = nil
    var data: T? {
        get {
            return _data
        }
        set {
            _data = newValue
        }
    }
}
