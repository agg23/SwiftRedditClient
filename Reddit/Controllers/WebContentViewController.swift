//
//  WebContentViewController.swift
//  Reddit
//
//  Created by Adam Gastineau on 6/23/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import AppKit
import WebKit

class WebContentViewController: NSViewController {
    let webView = WKWebView()
    
    override func loadView() {
        view = NSView()
        
        view.addSubview(webView)
        
        webView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.topMargin)
            make.bottom.equalTo(self.view.snp.bottomMargin)
            make.left.equalTo(self.view.snp.leftMargin)
            make.right.equalTo(self.view.snp.rightMargin)
        }
    }
    
    public func set(url: URL) {
        webView.load(URLRequest(url: url))
    }
}
