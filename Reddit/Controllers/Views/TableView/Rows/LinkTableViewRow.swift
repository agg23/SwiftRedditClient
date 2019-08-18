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
    override var data: Link? {
        get {
            return _data
        }
        set {
            _data = newValue
            
            let score = data?.score ?? 0
            
            titleLabel.stringValue = _data?.title ?? ""
            scoreLabel.stringValue = truncate(score)
            scoreLabel.toolTip = format(score)
            
            var color: NSColor?
            
            if let likes = data?.likes {
                color = likes ? .orange : .blue
            }
            
            scoreLabel.textColor = color
        }
    }
    
    let textCenterAlignImage: NSImage
    var _image: NSImage
    var image: NSImage? {
        get {
            return _image
        }
        set {
            if let newValue = newValue {
                _image = newValue
            } else {
                _image = textCenterAlignImage
            }
            
            imageView.image = _image
        }
    }
    
    let scoreStackView = NSStackView()
    let upvoteButton = NSButton()
    let scoreLabel = NSLabel()
    let downvoteButton = NSButton()
    
    let mainStackView = NSStackView()
    let titleLabel = NSLabel()
    let imageView = NSImageView()
    
    var upvoteButtonAction: ((_ data: Link, _ index: Int) -> Void)?
    var downvoteButtonAction: ((_ data: Link, _ index: Int) -> Void)?
    
    override init(frame frameRect: NSRect) {
        let textImage = NSImage(named: NSImage.listViewTemplateName)!
        textCenterAlignImage = textImage.resized(to: NSSize(width: 34, height: 34))!
        textCenterAlignImage.isTemplate = true
        
        _image = textCenterAlignImage
        
        super.init(frame: frameRect)
        
        imageView.image = _image
        
        addSubview(scoreStackView)
        addSubview(mainStackView)
        
        scoreStackView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        scoreStackView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultLow + 1, for: .horizontal)
        titleLabel.setContentHuggingPriority(.defaultLow - 1, for: .horizontal)
        
        scoreStackView.snp.makeConstraints { (make) in
            make.width.equalTo(40)
        }
        
        mainStackView.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.leftMargin).offset(10)
            make.right.equalTo(self.snp.rightMargin)
            make.top.equalTo(self.snp.topMargin)
            make.bottom.equalTo(self.snp.bottomMargin)
        }
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(imageView.snp.width)
        }
        
        mainStackView.setViews([scoreStackView, imageView, titleLabel], in: .center)
        mainStackView.orientation = .horizontal
        
        scoreStackView.setViews([upvoteButton, scoreLabel, downvoteButton], in: .center)
        scoreStackView.orientation = .vertical
        
        upvoteButton.title = "+1"
        upvoteButton.target = self
        upvoteButton.action = #selector(upvoteButtonClicked)
        
        downvoteButton.title = "-1"
        downvoteButton.target = self
        downvoteButton.action = #selector(downvoteButtonClicked)
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
    
    @objc func downvoteButtonClicked() {
        guard let data = data, let row = row, let downvoteButtonAction = downvoteButtonAction else {
            return
        }
        
        downvoteButtonAction(data, row)
    }
}
