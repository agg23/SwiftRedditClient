//
//  SelfPostViewController.swift
//  Reddit
//
//  Created by Adam Gastineau on 6/23/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import AppKit
import SnapKit

class SelfPostViewController: NSViewController {
    let titleLabel = NSLabel()
    let postLabel = NSLabel()
    
    override func loadView() {
        view = NSView()
        
        view.addSubview(titleLabel)
        view.addSubview(postLabel)
        
        titleLabel.setWrappable()
        postLabel.setWrappable()
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.topMargin)
            make.left.equalTo(self.view.snp.leftMargin)
            make.right.equalTo(self.view.snp.rightMargin)
        }
        
        postLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.equalTo(self.view.snp.bottomMargin)
            make.left.equalTo(self.view.snp.leftMargin)
            make.right.equalTo(self.view.snp.rightMargin)
        }
    }
    
    public func set(data: Link?) {
        guard let data = data else {
            return
        }
        
        titleLabel.stringValue = data.title
        postLabel.stringValue = data.selfText
    }
}
