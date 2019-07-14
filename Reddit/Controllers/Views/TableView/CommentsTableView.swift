//
//  CommentsTableView.swift
//  Reddit
//
//  Created by Adam Gastineau on 7/14/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import AppKit
import SnapKit

class CommentsTableView: ListingTableView<DisplayedComment, CommentTableViewRow> {
    public override var data: [DisplayedComment]? {
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
    
    func commentPreTraversal(with comments: [Comment]) -> [DisplayedComment] {
        var flattenedComments: [DisplayedComment] = []
        
        var stack: [DisplayedComment] = []
        
        // Add top level comments
        stack.append(contentsOf: comments.reversed().map { comment in
            return DisplayedComment(comment: comment, level: 0, more: nil)
        })
        
        while stack.count > 0, let displayComment = stack.popLast() {
            flattenedComments.append(displayComment)
            
            guard let replies = displayComment.comment?.replies else {
                continue
            }
            
            let childLevel = displayComment.level + 1
            
            let childComments = replies.comments

            if replies.more != nil {
                stack.append(DisplayedComment(comment: nil, level: childLevel, more: replies.more))
            }

            stack.append(contentsOf: childComments.reversed().map { comment in
                return DisplayedComment(comment: comment, level: childLevel, more: nil)
            })
        }
        
        return flattenedComments
    }
}
