//
//  SidebarView.swift
//  Reddit
//
//  Created by Adam Gastineau on 8/7/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import AppKit

class SidebarView: NSVisualEffectView {
    let sidebarView = SidebarTableView()
    
    public var data: [SidebarItem]? {
        get {
            return sidebarView.data
        }
        set {
            sidebarView.data = newValue
            sidebarView.reloadData()
        }
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        self.material = .sidebar
        
        addSubview(sidebarView)
        
        sidebarView.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.leftMargin)
            make.right.equalTo(self.snp.rightMargin)
            make.top.equalTo(self.snp.topMargin)
            make.bottom.equalTo(self.snp.bottomMargin)
        }
        
        sidebarView.backgroundColor = .clear
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
