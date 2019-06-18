//
//  ViewController.swift
//  Reddit
//
//  Created by Adam Gastineau on 6/17/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import AppKit
import SnapKit

class ListingViewController: NSViewController {
    let tableView = NSTableView()
    let labelView = NSTextField()
    
    override func loadView() {
        view = NSView()
//        view.addSubview(tableView)
        view.addSubview(labelView)
        labelView.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(50)
            make.center.equalTo(self.view)
        }
        labelView.stringValue = "Test string"
    }
}
