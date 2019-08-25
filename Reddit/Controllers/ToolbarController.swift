//
//  ToolbarController.swift
//  Reddit
//
//  Created by Adam Gastineau on 8/25/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import Cocoa

enum ToolbarItem: String {
    case postCommentGroup
}

enum ToolbarChildItem: String {
    case post
    case comment
}

class ToolbarController: NSObject {
    static let shared = ToolbarController()
    
    let toolbar: NSToolbar
    var items: [NSToolbarItem.Identifier] = [NSToolbarItem.Identifier.flexibleSpace, NSToolbarItem.Identifier(rawValue: ToolbarItem.postCommentGroup.rawValue)]
    
    override init() {
        toolbar = NSToolbar(identifier: "Toolbar")
        
        super.init()
        
        toolbar.delegate = self
        toolbar.displayMode = .iconOnly
    }
    
    @objc func clickPost() {
        print("Post")
    }
    
    @objc func clickComment() {
        print("Comment")
    }
}

extension ToolbarController: NSToolbarDelegate {
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        guard let identifier = ToolbarItem(rawValue: itemIdentifier.rawValue) else {
            return nil
        }
        
        switch identifier {
        case .postCommentGroup:
            let postItem = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier(rawValue: ToolbarChildItem.post.rawValue))
            postItem.image = NSImage(named: NSImage.bookmarksTemplateName)
            postItem.action = #selector(clickPost)
            postItem.target = self
            
            let commentItem = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier(rawValue: ToolbarChildItem.comment.rawValue))
            commentItem.image = NSImage(named: NSImage.pathTemplateName)
            commentItem.action = #selector(clickComment)
            commentItem.target = self
            
            let segmentedToolbar = SegmentedToolbar(itemIdentifier: NSToolbarItem.Identifier(rawValue: ToolbarItem.postCommentGroup.rawValue), items: [postItem, commentItem])
            return segmentedToolbar
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
