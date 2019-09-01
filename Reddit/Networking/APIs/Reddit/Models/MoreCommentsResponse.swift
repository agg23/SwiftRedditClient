//
//  MoreCommentsResponse.swift
//  Reddit
//
//  Created by Adam Gastineau on 7/14/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import Foundation

struct MoreCommentsResponse: Decodable {
    enum MoreCommentsKeys: String, CodingKey {
        case json
    }
    
    enum MoreCommentsInnerKeys: String, CodingKey {
        case things
    }
    
    let comments: [Comment]
    let commentMore: CommentMore?
    
    init(from decoder: Decoder) throws {
        let responseContainer = try decoder.container(keyedBy: MoreCommentsKeys.self)
        let thingContainer = try responseContainer.nestedContainer(keyedBy: ThingKeys.self, forKey: .json)
        let dataContainer = try thingContainer.nestedContainer(keyedBy: MoreCommentsInnerKeys.self, forKey: .data)
        let childrenContainer = try dataContainer.nestedUnkeyedContainer(forKey: .things)
        
        (comments, commentMore) = decodeCommentsAndMore(commentContainer: childrenContainer)
    }
}
