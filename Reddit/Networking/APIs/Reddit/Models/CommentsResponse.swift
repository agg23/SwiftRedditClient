//
//  CommentListing.swift
//  Reddit
//
//  Created by Adam Gastineau on 6/22/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import Foundation

struct CommentsResponse: Decodable {
    enum CommentsResponseError: Error {
        case invalidCount
    }
    
    let link: Listing<Link>
    let comments: CommentListing
    
    init(from decoder: Decoder) throws {
        var thingContainer = try decoder.unkeyedContainer()
        
        guard thingContainer.count == 2 else {
            throw CommentsResponseError.invalidCount
        }
        
        link = try thingContainer.decode(Listing<Link>.self)
        comments = try thingContainer.decode(CommentListing.self)
    }
}
