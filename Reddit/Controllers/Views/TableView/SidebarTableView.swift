//
//  SidebarTableView.swift
//  Reddit
//
//  Created by Adam Gastineau on 8/7/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import AppKit
import SnapKit

class SidebarTableView: ListingTableView<SidebarItem, SidebarTableViewRow> {
    public override var data: [SidebarItem]? {
        get {
            return _data
        }
        set {
            _data = newValue
        }
    }
}
