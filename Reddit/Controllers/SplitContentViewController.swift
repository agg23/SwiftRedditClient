//
//  MainViewController.swift
//  Reddit
//
//  Created by Adam Gastineau on 6/23/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import AppKit

class SplitContentViewController: NSViewController {
    let splitViewController = NSSplitViewController()

    let linkViewController = LinkViewController()
    let selfPostViewController: SelfPostViewController
    let webContentViewController: WebContentViewController
    
    let selfPostSplitItem: NSSplitViewItem
    let webContentSplitItem: NSSplitViewItem
    
    var activeSplitViewItem: NSSplitViewItem?
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        selfPostViewController = SelfPostViewController()
        webContentViewController = WebContentViewController()
        
        selfPostSplitItem = NSSplitViewItem(viewController: selfPostViewController)
        webContentSplitItem = NSSplitViewItem(viewController: webContentViewController)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = NSView()
        
        add(splitViewController)
        
        splitViewController.view.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.topMargin)
            make.bottom.equalTo(self.view.snp.bottomMargin)
            make.left.equalTo(self.view.snp.leftMargin)
            make.right.equalTo(self.view.snp.rightMargin)
        }
        
        let linkSplitItem = NSSplitViewItem(contentListWithViewController: linkViewController)
        linkSplitItem.holdingPriority = .init(251)
        webContentSplitItem.holdingPriority = .defaultLow
        selfPostSplitItem.holdingPriority = .defaultLow
        
        splitViewController.addSplitViewItem(linkSplitItem)
        activateWebContent()
        
        ToolbarController.shared.set(onClickPost: toolbarPostClicked)
        ToolbarController.shared.set(onClickComment: toolbarCommentClicked)
        
        linkViewController.set(onSelect: selected(link:index:))
    }
    
    override func viewWillAppear() {
        splitViewController.splitView.setPosition(300, ofDividerAt: 0)
    }
        
    func selected(link: Link, index: Int) {
        if link.isSelfPost(in: linkViewController.subreddit) {
            // Self Post
            selectSelfPost(with: link, index: index)
        } else {
            selectWebContent(with: link, index: index)
        }
    }
    
    func selectSelfPost(with link: Link, index: Int) {
        activateSelfPost()
        selfPostViewController.set(data: link)
    }
    
    func selectWebContent(with link: Link, index: Int) {
        activateWebContent()
        webContentViewController.set(url: URL(string: link.url)!)
    }
    
    func activateWebContent() {
        guard activeSplitViewItem != webContentSplitItem else {
            return
        }
        
        if let activeSplitViewItem = activeSplitViewItem {
            splitViewController.removeSplitViewItem(activeSplitViewItem)
        }
        splitViewController.addSplitViewItem(webContentSplitItem)
        activeSplitViewItem = webContentSplitItem
    }
    
    func activateSelfPost() {
        guard activeSplitViewItem != selfPostSplitItem else {
            return
        }
        
        if let activeSplitViewItem = activeSplitViewItem {
            splitViewController.removeSplitViewItem(activeSplitViewItem)
        }
        splitViewController.addSplitViewItem(selfPostSplitItem)
        activeSplitViewItem = selfPostSplitItem
    }
    
    func toolbarPostClicked() {
        guard let selectedLink = linkViewController.selectedLink, let selectedIndex = linkViewController.selectedIndex else {
            return
        }
        selected(link: selectedLink, index: selectedIndex)
    }
    
    func toolbarCommentClicked() {
        guard let selectedLink = linkViewController.selectedLink, let selectedIndex = linkViewController.selectedIndex else {
            return
        }
        selectSelfPost(with: selectedLink, index: selectedIndex)
    }
}
