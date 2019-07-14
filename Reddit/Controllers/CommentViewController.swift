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
    }
    
    public func set(data: Link?) {
        guard let data = data else {
            return
        }
        
        getComments(in: data.subreddit, on: data.id)
    }
    
    private func getComments(in subreddit: String, on post: String) {
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
}
