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
    let webContentViewController = WebContentViewController()

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
        let webContentSplitItem = NSSplitViewItem(sidebarWithViewController: webContentViewController)
        
        splitViewController.addSplitViewItem(linkSplitItem)
        splitViewController.addSplitViewItem(webContentSplitItem)
        
        linkViewController.set(onSelect: selected(link:))
    }
    
    func selected(link: Link) {
        webContentViewController.set(url: URL(string: link.url)!)
    }
}
