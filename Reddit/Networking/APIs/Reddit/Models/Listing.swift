//
//  Listing.swift
//  Reddit
//
//  Created by Adam Gastineau on 6/16/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import Foundation

enum ListingKeys: String, CodingKey {
    case kind
    
    case before
    case after
    case modhash
    case children
}

struct Listing<T: Decodable>: Decodable {
    // MARK: Thing
    let kind: String

    // MARK: Listing
    let before: String?
    let after: String?
    
    let modhash: String?
    let children: [T]
    
    init(from decoder: Decoder) throws {
        let thingContainer = try decoder.container(keyedBy: ThingKeys.self)
        
        kind = try thingContainer.decode(String.self, forKey: .kind)
        
        let container = try thingContainer.nestedContainer(keyedBy: ListingKeys.self, forKey: ThingKeys.data)

        before = try container.decodeIfPresent(String.self, forKey: .before)
        after = try container.decodeIfPresent(String.self, forKey: .after)
        modhash = try container.decodeIfPresent(String.self, forKey: .modhash)
        
        children = try container.decode([T].self, forKey: .children)        
    }
}
