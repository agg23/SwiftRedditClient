//
//  LinkTableViewRow.swift
//  Reddit
//
//  Created by Adam Gastineau on 6/18/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import AppKit
import SnapKit

class LinkTableViewRow: ListingTableViewRow<Link> {
    // MARK: ListingTableViewRow
    override var data: Link? {
        get {
            return _data
        }
        set {
            _data = newValue
            titleLabel.stringValue = _data?.title ?? ""
            scoreLabel.stringValue = "\(data?.score ?? 0)"
            
            var color: NSColor = .textColor
            
            if let likes = data?.likes {
                color = likes ? .orange : .blue
            }
            
            scoreLabel.textColor = color
        }
    }
    
    let scoreLabel = NSLabel()
    let titleLabel = NSLabel()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        addSubview(scoreLabel)
        addSubview(titleLabel)
        
        scoreLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        scoreLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.leftMargin)
            make.top.equalTo(self.snp.topMargin)
            make.bottom.equalTo(self.snp.bottomMargin)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(scoreLabel.snp.right).offset(10)
            make.right.equalTo(self.snp.rightMargin)
            make.top.equalTo(self.snp.topMargin)
            make.bottom.equalTo(self.snp.bottomMargin)
        }
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
