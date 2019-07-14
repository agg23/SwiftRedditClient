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
        data = commentPreTraversal(with: comments, initialDepth: 0)
    }
    
    public func insertComments(_ comments: [Comment], at index: Int, removingIndex: Bool = false) {
        guard let elementAtIndex = data?[index] else {
            return
        }
        
        if removingIndex {
            data?.remove(at: index)
        }
        
        let expandedComments = commentPreTraversal(with: comments, initialDepth: elementAtIndex.level)
        data?.insert(contentsOf: expandedComments, at: index)
    }
    
    public func removeComments(in range: Range<Int>) {
        data?.removeSubrange(range)
    }
    
    func commentPreTraversal(with comments: [Comment], initialDepth: Int) -> [DisplayedComment] {
        var flattenedComments: [DisplayedComment] = []
        
        var stack: [DisplayedComment] = []
        
        // Add top level comments
        stack.append(contentsOf: comments.reversed().map { comment in
            return DisplayedComment(comment: comment, level: initialDepth, more: nil)
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
