//
//  CommentViewController.swift
//  Reddit
//
//  Created by Adam Gastineau on 7/13/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import AppKit
import SnapKit
import PromiseKit

class CommentViewController: NSViewController {
    var link: Link?
    
    let tableView = CommentsTableView()
    
    override func loadView() {
        view = NSView()
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.topMargin)
            make.left.equalTo(self.view.snp.leftMargin)
            make.right.equalTo(self.view.snp.rightMargin)
            make.bottom.equalTo(self.view.snp.bottomMargin)
        }
        
        tableView.onSelect = onSelect
    }
    
    public func set(data: Link?) {
        link = data
        
        guard let data = data else {
            return
        }
        
        getComments(in: data.subreddit, on: data.id)
    }
    
    func onSelect(_ comment: DisplayedComment, index: Int) {
        if let more = comment.more {
            getMoreComments(for: more.children ?? [], insertAt: index)
        }
    }
    
    func getComments(in subreddit: String, on post: String) {
        firstly { () -> Promise<CommentsResponse> in
//            self.showSpinner()
            return RedditAPI.shared.request(from: .comments(in: subreddit, on: post))
        }.done { (data) in
            self.tableView.setComments(data.comments.comments)
            self.tableView.reloadData()
//            self.hideSpinner()
        }.catch { (error) in
            print(error)
        }
    }
    
    func getMoreComments(for children: [String], insertAt index: Int) {
        guard let link = link else {
            return
        }
        
        firstly { () -> Promise<MoreCommentsResponse> in
            return RedditAPI.shared.request(from: .moreComments(link: link.name, childrenIds: children))
        }.done { (data) in
            self.tableView.insertComments(data.comments, at: index, removingIndex: true)
            
            // Remove Show More row
            self.tableView.insert(rows: IndexSet(integersIn: index ..< index + data.comments.count), removing: IndexSet(integer: index), with: .slideDown)
        }.catch { (error) in
            print(error)
        }
    }
}
