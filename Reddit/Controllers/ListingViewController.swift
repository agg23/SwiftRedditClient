//
//  ViewController.swift
//  Reddit
//
//  Created by Adam Gastineau on 6/17/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import AppKit
import SnapKit
import Moya
import PromiseKit

let viewIdentifier = NSUserInterfaceItemIdentifier("listingViewRow")

class ListingViewController: NSViewController {
    let redditProvider = MoyaProvider<RedditAPITarget>()
    
    let scrollView = NSScrollView()
    let tableView = NSTableView()
    
    var data: Listing<Link>?
    
    override func loadView() {
        view = NSView()
        view.addSubview(scrollView)
        
        scrollView.hasVerticalScroller = true
        scrollView.documentView = tableView

        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.topMargin)
            make.left.equalTo(self.view.snp.leftMargin)
            make.right.equalTo(self.view.snp.rightMargin)
            make.bottom.equalTo(self.view.snp.bottomMargin)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.addTableColumn(NSTableColumn())
        tableView.headerView = nil
        
        tableView.layer = CALayer()
        tableView.layer?.backgroundColor = .white
    }
    
    override func viewDidAppear() {
        firstly { () -> Promise<Listing<Link>> in
            redditProvider.request(from: .getSubreddit("programming"))
        }.done { (data) in
            self.data = data
            self.tableView.reloadData()
        }.catch { (error) in
            print(error)
        }
    }
}

extension ListingViewController: NSTableViewDelegate, NSTableViewDataSource {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var rowView = tableView.makeView(withIdentifier: viewIdentifier, owner: self) as? LinkTableViewRow
        
        if rowView == nil {
            rowView = LinkTableViewRow()
            rowView?.identifier = viewIdentifier
        }
        
        guard let link = data?.children[row] else {
            return rowView
        }
        
        rowView?.titleLabel.stringValue = link.title
        
        return rowView
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return data?.children.count ?? 0
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 40
    }
}
