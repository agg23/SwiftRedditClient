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
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.disableSelection = true
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setComments(_ comments: [Comment]) {
        let displayCommentsArray = displayComments(from: comments, depth: 0)
        data = commentPreTraversal(with: displayCommentsArray)
    }
    
    public func insertComments(_ comments: [Comment], at index: Int, removingIndex: Bool = false) {
        guard let elementAtIndex = data?[index] else {
            return
        }
        
        if removingIndex {
            data?.remove(at: index)
        }
        
        let displayCommentsArray = displayComments(from: comments, depth: elementAtIndex.level)
        let expandedComments = commentPreTraversal(with: displayCommentsArray)
        data?.insert(contentsOf: expandedComments, at: index)
    }
    
    public func removeComments(in range: Range<Int>) {
        data?.removeSubrange(range)
    }
    
    func displayComments(from comments: [Comment], depth: Int) -> [DisplayedComment] {
        return comments.reversed().map { comment in
            return DisplayedComment(comment: comment, level: depth, more: nil)
        }
    }
    
    func commentPreTraversal(with nestedComments: [DisplayedComment]) -> [DisplayedComment] {
        var flattenedComments: [DisplayedComment] = []
        
        var stack: [DisplayedComment] = []
        
        stack.append(contentsOf: nestedComments)
        
        while stack.count > 0, let displayComment = stack.popLast() {
            // TODO: Save nested display comments for later re-parsing
            guard !displayComment.collapsed else {
                continue
            }
            
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
