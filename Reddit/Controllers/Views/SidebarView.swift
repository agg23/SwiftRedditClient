//
//  SidebarView.swift
//  Reddit
//
//  Created by Adam Gastineau on 8/7/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import AppKit

class SidebarView: NSVisualEffectView {
    let sidebarTableView = SidebarTableView()
    
    public var data: [SidebarItem]? {
        get {
            return sidebarTableView.data
        }
        set {
            sidebarTableView.data = newValue
            sidebarTableView.reloadData()
        }
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        self.material = .sidebar
        
        addSubview(sidebarTableView)
        
        sidebarTableView.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.leftMargin)
            make.right.equalTo(self.snp.rightMargin)
            make.top.equalTo(self.snp.topMargin)
            make.bottom.equalTo(self.snp.bottomMargin)
        }
        
        sidebarTableView.backgroundColor = .clear
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func set(onSelect: ((SidebarItem, Int) -> Void)?) {
        sidebarTableView.onSelect = onSelect
    }
}
