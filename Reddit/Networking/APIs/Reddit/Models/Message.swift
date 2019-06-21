//
//  Message.swift
//  Reddit
//
//  Created by Adam Gastineau on 6/20/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import Foundation

struct Message: Thing, Created, Decodable {
    enum MessageKeys: String, CodingKey {
        case id
        case name
        
        case created
        case createdUtc = "created_utc"
        
        case author
        case body
        case bodyHtml = "body_html"
        case context
        case firstMessage = "first_message"
        case firstMessageName = "first_message_name"
        case likes
        case linkTitle = "link_title"
        case new
        case parentId = "parent_id"
        case replies
        case subject
        case subreddit
        case wasComment = "was_comment"
    }
    
    // MARK: Thing
    let id: String
    let name: String
    let kind: String
    
    // MARK: Created
    let created: Int
    let createdUtc: Int
    
    // MARK: Link
    let author: String
    let body: String
    let bodyHtml: String
    let context: String?
    
    let firstMessage: Int?
    let firstMessageName: String?
    
    let likes: Bool?

    let linkTitle: String?
    let new: Bool
    
    let parentId: String?
    let replies: String?
    let subject: String
    let subreddit: String?
    
    let wasComment: Bool
    
    init(from decoder: Decoder) throws {
        let thingContainer = try decoder.container(keyedBy: ThingKeys.self)
        
        kind = try thingContainer.decode(String.self, forKey: .kind)
        
        let container = try thingContainer.nestedContainer(keyedBy: MessageKeys.self, forKey: ThingKeys.data)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        
        created = try container.decode(Int.self, forKey: .created)
        createdUtc = try container.decode(Int.self, forKey: .createdUtc)
        
        author = try container.decode(String.self, forKey: .author)
        body = try container.decode(String.self, forKey: .body)
        bodyHtml = try container.decode(String.self, forKey: .bodyHtml)
        context = try container.decodeIfPresent(String.self, forKey: .context)
        
        firstMessage = try container.decodeIfPresent(Int.self, forKey: .firstMessage)
        firstMessageName = try container.decodeIfPresent(String.self, forKey: .firstMessageName)
        
        likes = try container.decodeIfPresent(Bool.self, forKey: .likes)
        
        linkTitle = try container.decodeIfPresent(String.self, forKey: .linkTitle)
        new = try container.decode(Bool.self, forKey: .new)
        
        parentId = try container.decodeIfPresent(String.self, forKey: .parentId)
        replies = try container.decodeIfPresent(String.self, forKey: .replies)
        subject = try container.decode(String.self, forKey: .subject)
        subreddit = try container.decodeIfPresent(String.self, forKey: .subreddit)
        
        wasComment = try container.decode(Bool.self, forKey: .wasComment)        
    }
}
