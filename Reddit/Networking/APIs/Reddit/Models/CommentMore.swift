//
//  CommentMore.swift
//  Reddit
//
//  Created by Adam Gastineau on 6/22/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import Foundation

struct CommentMore: Thing, Decodable {
    enum CommentMoreKeys: String, CodingKey {
        case id
        case name
        
        case parentId = "parent_id"
        
        case children
    }
    
    // MARK: Thing
    let id: String
    let name: String
    let kind: String
    
    // MARK: CommentMore
    let parentId: String?
    let children: [String]?
    
    init(from decoder: Decoder) throws {
        let thingContainer = try decoder.container(keyedBy: ThingKeys.self)
        
        kind = try thingContainer.decode(String.self, forKey: .kind)
        
        let container = try thingContainer.nestedContainer(keyedBy: CommentMoreKeys.self, forKey: ThingKeys.data)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        
        parentId = try container.decodeIfPresent(String.self, forKey: .parentId)
        children = try container.decodeIfPresent([String].self, forKey: .children)
    }
}

