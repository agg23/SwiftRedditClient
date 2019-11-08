//
//  LinkTableView.swift
//  Reddit
//
//  Created by Adam Gastineau on 8/18/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import Cocoa

class LinkTableView: ListingTableView<Link, LinkTableViewRow> {    
    // MARK: NSTableViewDelegate, NSTableViewDataSource
    // These cannot appear in an extension due to the generics and ObjC
    override func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let newRowView = super.tableView(tableView, viewFor: tableColumn, row: row)
        
        guard let rowView = newRowView as? LinkTableViewRow, let value = data?[row] else {
            return newRowView
        }
        
        rowView.image = nil
        
        if value.thumbnail != "" && value.thumbnail != "self" {
            ImageCache.shared.image(for: value.thumbnail) { result in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let imageFetchResult):
                    var columnIndex = 0
                    
                    if let tableColumn = tableColumn {
                        columnIndex = tableView.tableColumns.firstIndex(of: tableColumn) ?? 0
                    }
                    
                    guard let rowViewToUpdate = self.tableView.view(atColumn: columnIndex, row: row, makeIfNecessary: false) as! LinkTableViewRow? else {
                        return
                    }
                    
                    rowViewToUpdate.image = imageFetchResult.image
                }
            }
        }
        
        return rowView
    }
}
