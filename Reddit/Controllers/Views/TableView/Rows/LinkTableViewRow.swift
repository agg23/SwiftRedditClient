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
    
    let scoreStackView = NSStackView()
    let scoreLabel = NSLabel()
    let upvoteButton = NSButton()
    let titleLabel = NSLabel()
    
    var upvoteButtonAction: ((_ data: Link, _ index: Int) -> Void)?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        addSubview(scoreStackView)
        addSubview(titleLabel)
        
        scoreStackView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        scoreStackView.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.leftMargin)
            make.top.equalTo(self.snp.topMargin)
            make.bottom.equalTo(self.snp.bottomMargin)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(scoreStackView.snp.right).offset(10)
            make.right.equalTo(self.snp.rightMargin)
            make.top.equalTo(self.snp.topMargin)
            make.bottom.equalTo(self.snp.bottomMargin)
        }
        
        scoreStackView.setViews([scoreLabel, upvoteButton], in: .center)
        scoreStackView.orientation = .vertical
        
        upvoteButton.title = "+1"
        upvoteButton.target = self
        upvoteButton.action = #selector(upvoteButtonClicked)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func upvoteButtonClicked() {
        guard let data = data, let row = row, let upvoteButtonAction = upvoteButtonAction else {
            return
        }
        
        upvoteButtonAction(data, row)
    }
}
