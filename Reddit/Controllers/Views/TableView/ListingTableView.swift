//
//  ListingTableView.swift
//  Reddit
//
//  Created by Adam Gastineau on 6/23/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import AppKit
import SnapKit

class ListingTableView<TData, TCellView: ListingTableViewRow<TData>>: NSView, NSTableViewDelegate, NSTableViewDataSource {
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
    
    var _backgroundColor: NSColor = .white
    public var backgroundColor: NSColor {
        get {
            return _backgroundColor
        }
        set {
            _backgroundColor = newValue
            tableView.backgroundColor = _backgroundColor
        }
    }
    
    public var disableSelection = false
    
    public var onRegisterActions: ((_ cell: TCellView, _ data: TData, _ index: Int) -> Void)?
    public var onSelect: ((TData, _ index: Int) -> Void)?
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

        scrollView.backgroundColor = .clear
        scrollView.drawsBackground = false
        
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
        
        tableView.backgroundColor = _backgroundColor
        
//        tableView.layer = CALayer()
//        tableView.layer?.backgroundColor = _backgroundColor
        
//        tableView.backgroundColor = .systemGray
        
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
    
    public func scrollToTop() {
        tableView.scrollRowToVisible(0)
    }
    
    public func insert(rows: IndexSet, removing removedRows: IndexSet? = nil, with animation: NSTableView.AnimationOptions = .effectFade) {
        tableView.beginUpdates()
        if let removedRows = removedRows {
            tableView.removeRows(at: removedRows, withAnimation: animation)
        }
        tableView.insertRows(at: rows, withAnimation: animation)
        tableView.endUpdates()
    }
    
    public func reloadData(forRowIndexes: IndexSet) {
        tableView.reloadData(forRowIndexes: forRowIndexes, columnIndexes: IndexSet(integer: 0))
    }
    
    public func resetNearBottomFired() {
        nearBottomFired = false
    }
    
    func populateRowView(in tableView: NSTableView, row: Int, shouldRegister: Bool = false) -> NSView? {
        var newRowView = tableView.makeView(withIdentifier: viewIdentifier, owner: self) as? TCellView
        
        if newRowView == nil {
            newRowView = TCellView()
            newRowView?.identifier = viewIdentifier
        }
        
        guard let rowView = newRowView, let value = data?[row] else {
            return newRowView
        }
        
        rowView.data = value
        rowView.row = row
        
        if shouldRegister, let onRegisterActions = onRegisterActions {
            onRegisterActions(rowView, value, row)
        }
        
        return rowView
    }
    
    // MARK: NSTableViewDelegate, NSTableViewDataSource
    // These cannot appear in an extension due to the generics and ObjC
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        return populateRowView(in: tableView, row: row, shouldRegister: true)
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return data?.count ?? 0
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        let view = populateRowView(in: tableView, row: row)
        
        view?.frame.size.width = tableView.bounds.size.width
        view?.needsLayout = true
        view?.layoutSubtreeIfNeeded()
        
        return view?.fittingSize.height ?? 10
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let row = tableView.selectedRow
        guard row != -1, let value = data?[row], let onSelect = onSelect else {
            return
        }
        
        print("Selected \(row)")
        onSelect(value, row)
    }
    
    func tableViewColumnDidResize(_ notification: Notification) {
        let allIndexes = IndexSet(integersIn: 0..<tableView.numberOfRows)
        
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current.duration = 0
        tableView.noteHeightOfRows(withIndexesChanged: allIndexes)
        NSAnimationContext.endGrouping()
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
    
    func tableView(_ tableView: NSTableView, selectionIndexesForProposedSelection proposedSelectionIndexes: IndexSet) -> IndexSet {
        if disableSelection {
            return IndexSet()
        }
        
        return proposedSelectionIndexes
    }
}
