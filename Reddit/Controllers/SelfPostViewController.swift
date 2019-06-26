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
    let scrollView = NSScrollView()
    
    let contentView = NSView()
    
    let titleLabel = NSLabel()
    let postLabel = NSLabel()
    
    override func loadView() {
        view = NSView()
        
        view.addSubview(scrollView)
        scrollView.documentView = contentView
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(postLabel)
        
        titleLabel.setWrappable()
        postLabel.setWrappable()

        titleLabel.font = .boldSystemFont(ofSize: 15)
        titleLabel.textColor = .textColor
        postLabel.textColor = .textColor
        
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.topMargin)
            make.bottom.equalTo(self.view.snp.bottomMargin)
            make.left.equalTo(self.view.snp.leftMargin)
            make.right.equalTo(self.view.snp.rightMargin)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(scrollView.snp.topMargin)
            make.bottom.greaterThanOrEqualTo(scrollView.snp.bottomMargin)
            make.left.equalTo(scrollView.snp.leftMargin)
            make.right.equalTo(scrollView.snp.rightMargin)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.topMargin)
            make.left.equalTo(contentView.snp.leftMargin)
            make.right.equalTo(contentView.snp.rightMargin)
        }
        
        postLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.bottom.lessThanOrEqualTo(contentView.snp.bottomMargin)
            make.left.equalTo(contentView.snp.leftMargin)
            make.right.equalTo(contentView.snp.rightMargin)
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
