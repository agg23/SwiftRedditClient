//
//  CommentsTableView.swift
//  Reddit
//
//  Created by Adam Gastineau on 7/14/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import AppKit
import SnapKit

class CommentsTableView: ListingTableView<(Comment, Int), CommentTableViewRow> {
    public override var data: [(Comment, Int)]? {
        get {
            return _data
        }
        set {
            _data = newValue
            nearBottomFired = false
        }
    }
    
    public func setComments(_ comments: [Comment]) {
        data = commentPreTraversal(with: comments)
    }
    
    func commentPreTraversal(with comments: [Comment]) -> [(Comment, Int)] {
        var flattenedComments: [(Comment, Int)] = []
        
        var stack: [(Comment, Int)] = []
        
        // Add top level comments
        stack.append(contentsOf: comments.reversed().map { comment in
            return (comment, 0)
        })
        
        while stack.count > 0, let commentTuple = stack.popLast() {
            let comment = commentTuple.0
            let level = commentTuple.1
            flattenedComments.append(commentTuple)
            
            let childComments = comment.replies?.comments ?? []
            stack.append(contentsOf: childComments.reversed().map { comment in
                return (comment, level + 1)
            })
        }
        
        return flattenedComments
    }
}
