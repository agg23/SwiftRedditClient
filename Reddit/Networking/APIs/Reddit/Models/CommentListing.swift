//
//  CommentListing.swift
//  Reddit
//
//  Created by Adam Gastineau on 6/22/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import Foundation

struct CommentListing: Decodable {
    // MARK: Thing
    let kind: String
    
    // MARK: Listing
    let before: String?
    let after: String?
    
    let modhash: String?
    let comments: [Comment]
    let more: CommentMore?
    
    init(from decoder: Decoder) throws {
        let thingContainer = try decoder.container(keyedBy: ThingKeys.self)
        
        kind = try thingContainer.decode(String.self, forKey: .kind)
        
        let container = try thingContainer.nestedContainer(keyedBy: ListingKeys.self, forKey: ThingKeys.data)
        
        before = try container.decodeIfPresent(String.self, forKey: .before)
        after = try container.decodeIfPresent(String.self, forKey: .after)
        modhash = try container.decodeIfPresent(String.self, forKey: .modhash)
        
        var childrenContainer = try container.nestedUnkeyedContainer(forKey: .children)
        
        let childrenCount = childrenContainer.count ?? 0
        
        var foundComments: [Comment] = []
        var foundMore: CommentMore?
        
        for i in 0..<childrenCount {
            if i == childrenCount - 1 {
                foundMore = try childrenContainer.decodeIfPresent(CommentMore.self)
            } else {
                let comment = try childrenContainer.decode(Comment.self)
                foundComments.append(comment)
            }
        }
        
        comments = foundComments
        more = foundMore
    }
}
