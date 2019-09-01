//
//  CommentUtil.swift
//  Reddit
//
//  Created by Adam Gastineau on 9/1/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import Foundation

func decodeCommentsAndMore(commentContainer: UnkeyedDecodingContainer) -> ([Comment], CommentMore?) {
    var commentContainer = commentContainer
    var copiedCommentContainer = commentContainer
    
    let childrenCount = commentContainer.count ?? 0
    
    var foundComments: [Comment] = []
    var foundMore: CommentMore?
    
    for _ in 0..<childrenCount {        
        do {
            let more = try copiedCommentContainer.decodeIfPresent(CommentMore.self)
            
            if more?.kind == "more" {
                // Is More
                foundMore = more
                let _ = try commentContainer.decodeIfPresent(CommentMore.self)
                continue
            }
        } catch {
            // Ignore
        }
        
        do {
            let comment = try commentContainer.decode(Comment.self)
            foundComments.append(comment)
        } catch {
            print(error)
        }
    }
    
    return (foundComments, foundMore)
}
