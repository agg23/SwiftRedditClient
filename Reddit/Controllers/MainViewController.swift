//
//  MainViewController.swift
//  Reddit
//
//  Created by Adam Gastineau on 6/23/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import AppKit

class MainViewController: NSViewController {
    let splitViewController = NSSplitViewController()

    let linkViewController = LinkViewController()
    let selfPostViewController: SelfPostViewController
    let webContentViewController: WebContentViewController
    
    let selfPostSplitItem: NSSplitViewItem
    let webContentSplitItem: NSSplitViewItem
    
    var activeSplitViewItem: NSSplitViewItem
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        selfPostViewController = SelfPostViewController()
        webContentViewController = WebContentViewController()
        
        selfPostSplitItem = NSSplitViewItem(sidebarWithViewController: selfPostViewController)
        webContentSplitItem = NSSplitViewItem(sidebarWithViewController: webContentViewController)
        
        activeSplitViewItem = webContentSplitItem
        
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
        
        splitViewController.addSplitViewItem(linkSplitItem)
        splitViewController.addSplitViewItem(webContentSplitItem)
        
        linkViewController.set(onSelect: selected(link:))
    }
    
    func selected(link: Link) {
        if link.isSelfPost(in: linkViewController.subreddit) {
            // Self Post
            activateSelfPost()
            selfPostViewController.set(data: link)
        } else {
            activateWebContent()
            webContentViewController.set(url: URL(string: link.url)!)
        }
    }
    
    func activateWebContent() {
        guard activeSplitViewItem != webContentSplitItem else {
            return
        }
        
        splitViewController.removeSplitViewItem(activeSplitViewItem)
        splitViewController.addSplitViewItem(webContentSplitItem)
        activeSplitViewItem = webContentSplitItem
    }
    
    func activateSelfPost() {
        guard activeSplitViewItem != selfPostSplitItem else {
            return
        }
        
        splitViewController.removeSplitViewItem(activeSplitViewItem)
        splitViewController.addSplitViewItem(selfPostSplitItem)
        activeSplitViewItem = selfPostSplitItem
    }
}
