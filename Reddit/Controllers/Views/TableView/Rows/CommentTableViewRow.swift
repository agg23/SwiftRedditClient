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
            
            usernameLabel.stringValue = data.comment?.author ?? ""
            textLabel.stringValue = data.comment?.body ?? (data.more != nil ? "Show more" : "")
            indentSpacer.snp.updateConstraints { make in
                make.width.equalTo(levelWidth(for: data.level))
            }
        }
    }
    
    let indentSpacer = NSView()
    let contentView = NSView()
    let usernameLabel = NSLabel()
    let textLabel = NSLabel()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        addSubview(indentSpacer)
        addSubview(contentView)
        
        contentView.addSubview(usernameLabel)
        contentView.addSubview(textLabel)
        
        indentSpacer.snp.makeConstraints { make in
            make.left.equalTo(self.snp.leftMargin)
            make.width.equalTo(0)
            make.top.equalTo(self.snp.topMargin)
            make.bottom.equalTo(self.snp.bottomMargin)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.left.equalTo(indentSpacer.snp.right)
            make.right.equalTo(self.snp.rightMargin)
            make.top.equalTo(self.snp.topMargin)
            make.bottom.equalTo(self.snp.bottomMargin)
        }
        
        usernameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.rightMargin)
            make.right.equalTo(contentView.snp.rightMargin)
            make.top.equalTo(contentView.snp.topMargin)
        }
        
        textLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        textLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.rightMargin)
            make.right.equalTo(contentView.snp.rightMargin)
            make.top.equalTo(usernameLabel.snp.bottom).offset(6)
            make.bottom.equalTo(contentView.snp.bottomMargin)
        }
        
        // TODO: Fix
        usernameLabel.target = self
        usernameLabel.action = #selector(usernameClick)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func levelWidth(for level: Int) -> Int {
        return level * 20
    }
    
    @objc func usernameClick() {
        guard let username = data?.comment?.author,
            let url = URL(string: "https://www.reddit.com/user/\(username)") else {
            return
        }
        
        NSWorkspace.shared.open(url)
    }
}
