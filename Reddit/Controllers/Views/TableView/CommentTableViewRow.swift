//
//  CommentTableViewRow.swift
//  Reddit
//
//  Created by Adam Gastineau on 7/13/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import AppKit
import SnapKit

class CommentTableViewRow: ListingTableViewRow<(Comment, Int)> {
    // MARK: ListingTableViewRow
    override var data: (Comment, Int)? {
        get {
            return _data
        }
        set {
            _data = newValue
            titleLabel.stringValue = _data?.0.body ?? ""
        }
    }
    
    let titleLabel = NSLabel()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        addSubview(titleLabel)
        
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.leftMargin)
            make.right.equalTo(self.snp.rightMargin)
            make.top.equalTo(self.snp.topMargin)
            make.bottom.equalTo(self.snp.bottomMargin)
        }
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
