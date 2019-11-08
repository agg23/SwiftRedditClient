//
//  DisplayedComment.swift
//  Reddit
//
//  Created by Adam Gastineau on 7/14/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import Foundation

struct DisplayedComment {
    let comment: Comment?
    let level: Int
    let more: CommentMore?
    let collapsed: Bool = false
}
