//
//  MainViewController.swift
//  Reddit
//
//  Created by Adam Gastineau on 8/7/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import AppKit

class MainViewController: NSViewController {
    let splitContentViewController = SplitContentViewController()
    
    let sidebarView = SidebarView()
    
    let sidebarItems = [SidebarItem(title: "Subreddits"), SidebarItem(title: "Messages")]
    
    override func loadView() {
        sidebarView.data = sidebarItems
        
        view = NSView()
        
        view.addSubview(sidebarView)
        add(splitContentViewController)
        
        sidebarView.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.topMargin)
            make.bottom.equalTo(self.view.snp.bottomMargin)
            make.left.equalTo(self.view.snp.leftMargin)
            make.width.equalTo(200)
        }
        
        splitContentViewController.view.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.topMargin)
            make.bottom.equalTo(self.view.snp.bottomMargin)
            make.left.equalTo(sidebarView.snp.right)
            make.right.equalTo(self.view.snp.rightMargin)
        }
    }
}
