//
//  ListingTableView.swift
//  Reddit
//
//  Created by Adam Gastineau on 6/23/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import AppKit
import SnapKit

class ListingTableView<TData: Thing, TCellView: ListingTableViewRow<TData>>: NSView, NSTableViewDelegate, NSTableViewDataSource {
    let viewIdentifier = NSUserInterfaceItemIdentifier("listingViewRow.\(TCellView.self)")
    lazy var notificationCenter: NotificationCenter = NotificationCenter.default
    
    var _data: [TData]?
    public var data: [TData]? {
        get {
            return _data
        }
        set {
            _data = newValue
            nearBottomFired = false
        }
    }
    public var onSelect: ((TData) -> Void)?
    public var onNearScrollBottom: (() -> Void)?
    var nearBottomFired = false
    
    public var scrollLoadIndex: Int?
    
    let scrollView = NSScrollView()
    let tableView = NSTableView()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        addSubview(scrollView)
        
        scrollView.hasVerticalScroller = true
        scrollView.documentView = tableView
        
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.topMargin)
            make.left.equalTo(self.snp.leftMargin)
            make.right.equalTo(self.snp.rightMargin)
            make.bottom.equalTo(self.snp.bottomMargin)
        }
        
        tableView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.addTableColumn(NSTableColumn())
        tableView.headerView = nil
        
        tableView.layer = CALayer()
        tableView.layer?.backgroundColor = .white
        
        let clipView = scrollView.contentView
        notificationCenter.addObserver(self, selector: #selector(scrollViewContentBoundsDidChange), name: NSView.boundsDidChangeNotification, object: clipView)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    // MARK: NSTableView
    
    public func reloadData() {
        tableView.reloadData()
    }
    
    public func insert(rows: IndexSet) {
        tableView.beginUpdates()
        tableView.insertRows(at: rows, withAnimation: .effectFade)
        tableView.endUpdates()
    }
    
    public func resetNearBottomFired() {
        nearBottomFired = false
    }
    
    // MARK: NSTableViewDelegate, NSTableViewDataSource
    // These cannot appear in an extension due to the generics and ObjC
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var rowView = tableView.makeView(withIdentifier: viewIdentifier, owner: self) as? TCellView
        
        if rowView == nil {
            rowView = TCellView()
            rowView?.identifier = viewIdentifier
        }
        
        guard let value = data?[row] else {
            return rowView
        }
        
        rowView?.data = value
        
        return rowView
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return data?.count ?? 0
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 40
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let row = tableView.selectedRow
        guard row != -1, let value = data?[row], let onSelect = onSelect else {
            return
        }
        onSelect(value)
    }
    
    // MARK: ScrollView
    
    @objc func scrollViewContentBoundsDidChange(_ notification: Notification) {
        guard !nearBottomFired,
            let scrolledView = notification.object as? NSClipView,
            let onNearScrollBottom = onNearScrollBottom else {
            return
        }
        
        let bounds = scrolledView.bounds
        let contentHeight = scrollView.documentView?.frame.size.height ?? 0
        
        if bounds.origin.y > contentHeight - 2 * bounds.size.height {
            // Within 2 table heights of bottom
            print("Bottom")
            nearBottomFired = true
            onNearScrollBottom()
        }
    }
}
