//
//  ToolbarController.swift
//  Reddit
//
//  Created by Adam Gastineau on 8/25/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import Cocoa

enum ToolbarItem: String {
    case subredditTextField
    case safariButton
    case postCommentGroup
}

enum ToolbarChildItem: String {
    case post
    case comment
}

class ToolbarController: NSObject {
    static let shared = ToolbarController()
    
    let toolbar: NSToolbar
    var segmentedToolbar: SegmentedToolbar?
    var items: [NSToolbarItem.Identifier] = [
        NSToolbarItem.Identifier.flexibleSpace,
        NSToolbarItem.Identifier(rawValue: ToolbarItem.subredditTextField.rawValue),
        NSToolbarItem.Identifier.flexibleSpace,
        NSToolbarItem.Identifier(rawValue: ToolbarItem.safariButton.rawValue),
        NSToolbarItem.Identifier(rawValue: ToolbarItem.postCommentGroup.rawValue)]
    
    var onClickShare: (() -> Void)?
    var onClickPost: (() -> Void)?
    var onClickComment: (() -> Void)?
    
    override init() {
        toolbar = NSToolbar(identifier: "Toolbar")
        
        super.init()
        
        toolbar.delegate = self
        toolbar.displayMode = .iconOnly
    }
    
    public func set(onClickShare: (() -> Void)?) {
        self.onClickShare = onClickShare
    }
    
    public func set(onClickPost: (() -> Void)?) {
        self.onClickPost = onClickPost
    }
    
    public func set(onClickComment: (() -> Void)?) {
        self.onClickComment = onClickComment
    }
    
    @objc func clickShare() {
        guard let onClickShare = onClickShare else {
            return
        }
        
        onClickShare()
    }
    
    @objc func clickPost() {
        guard let onClickPost = onClickPost else {
            return
        }
        
        onClickPost()
    }
    
    @objc func clickComment() {
        guard let onClickComment = onClickComment else {
            return
        }
        
        onClickComment()
    }
    
    func highlight(post: Bool) {
        segmentedToolbar?.segmentedControl.selectedSegment = post ? 0 : 1
    }
}

extension ToolbarController: NSToolbarDelegate {
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        guard let identifier = ToolbarItem(rawValue: itemIdentifier.rawValue) else {
            return nil
        }
        
        switch identifier {
        case .subredditTextField:
            let subredditItem = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier(rawValue: ToolbarItem.subredditTextField.rawValue))
            let textField = NSTextField()
            subredditItem.view = textField
            
            return subredditItem
        case .safariButton:
            let safariItem = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier(rawValue: ToolbarItem.safariButton.rawValue))
            let button = NSButton()
            button.image = NSImage(named: NSImage.shareTemplateName)
            button.bezelStyle = .texturedRounded
            button.action = #selector(clickShare)
            button.target = self
            
            safariItem.view = button
            
            return safariItem
        case .postCommentGroup:
            let postItem = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier(rawValue: ToolbarChildItem.post.rawValue))
            postItem.image = NSImage(named: NSImage.bookmarksTemplateName)
            postItem.action = #selector(clickPost)
            postItem.target = self
            
            let commentItem = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier(rawValue: ToolbarChildItem.comment.rawValue))
            commentItem.image = NSImage(named: NSImage.pathTemplateName)
            commentItem.action = #selector(clickComment)
            commentItem.target = self
            
            let segmented = SegmentedToolbar(itemIdentifier: NSToolbarItem.Identifier(rawValue: ToolbarItem.postCommentGroup.rawValue), items: [postItem, commentItem])
            segmentedToolbar = segmented
            return segmented
        }
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return items
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return items
    }
    
    func toolbarSelectableItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return items
    }
}
