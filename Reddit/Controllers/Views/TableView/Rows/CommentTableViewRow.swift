//
//  CommentTableViewRow.swift
//  Reddit
//
//  Created by Adam Gastineau on 7/13/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import AppKit
import SnapKit

class CommentTableViewRow: ListingTableViewRow<DisplayedComment> {
    // MARK: ListingTableViewRow
    override var data: DisplayedComment? {
        get {
            return _data
        }
        set {
            _data = newValue
            
            guard let data = _data else {
                return
            }
            
            titleLabel.stringValue = data.comment?.body ?? (data.more != nil ? "Show more" : "")
            indentSpacer.snp.updateConstraints { make in
                make.width.equalTo(levelWidth(for: data.level))
            }
        }
    }
    
    let indentSpacer = NSView()
    let titleLabel = NSLabel()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        addSubview(indentSpacer)
        addSubview(titleLabel)
        
        indentSpacer.snp.makeConstraints { make in
            make.left.equalTo(self.snp.leftMargin)
            make.width.equalTo(0)
            make.top.equalTo(self.snp.topMargin)
            make.bottom.equalTo(self.snp.bottomMargin)
        }
        
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(indentSpacer.snp.right)
            make.right.equalTo(self.snp.rightMargin)
            make.top.equalTo(self.snp.topMargin)
            make.bottom.equalTo(self.snp.bottomMargin)
        }
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func levelWidth(for level: Int) -> Int {
        return level * 20
    }
}
