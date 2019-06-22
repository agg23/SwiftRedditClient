//
//  Comment.swift
//  Reddit
//
//  Created by Adam Gastineau on 6/22/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import Foundation

struct Comment: Votable, Created, Decodable {
    enum CommentKeys: String, CodingKey {
        case id
        case name
        
        case created
        case createdUtc = "created_utc"
        
        case ups
        case downs
        case likes
        
        case author
        case authorFlairCssClass = "author_flair_css_class"
        case authorFlairText = "author_flair_text"
        
        case bannedBy = "banned_by"
        
        case body
        case bodyHtml = "body_html"
        
        case edited
        case gilded

        case linkAuthor = "link_author"
        case linkId = "link_id"
        case linkTitle = "link_title"
        case linkUrl = "link_url"
        
        case numReports = "num_reports"
        
        case parentId = "parent_id"
        
        case replies
        
        case saved
        case score
        case scoreHidden = "score_hidden"
        
        case subreddit
        case subredditId = "subreddit_id"
        case distinguished
    }
    
    // MARK: Thing
    let id: String
    let name: String
    let kind: String
    
    // MARK: Created
    let created: Int
    let createdUtc: Int
    
    // MARK: Votable
    let ups: Int
    let downs: Int
    let likes: Bool?
    
    // MARK: Comment
    let author: String
    let authorFlairCssClass: String?
    let authorFlairText: String?
    
    let bannedBy: String?

    let body: String
    let bodyHtml: String
    
    let edited: Date?
    let gilded: Int

    let linkAuthor: String?
    let linkId: String
    let linkTitle: String?
    let linkUrl: String?
    
    let numReports: Int?
    
    let parentId: String
    
    let replies: CommentListing?

    let saved: Bool?
    let score: Int
    let scoreHidden: Bool
    
    let subreddit: String
    let subredditId: String
    let distinguished: String?
    
    init(from decoder: Decoder) throws {
        let thingContainer = try decoder.container(keyedBy: ThingKeys.self)
        
        kind = try thingContainer.decode(String.self, forKey: .kind)
        
        let container = try thingContainer.nestedContainer(keyedBy: CommentKeys.self, forKey: ThingKeys.data)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        
        created = try container.decode(Int.self, forKey: .created)
        createdUtc = try container.decode(Int.self, forKey: .createdUtc)
        
        ups = try container.decode(Int.self, forKey: .ups)
        downs = try container.decode(Int.self, forKey: .downs)
        likes = try container.decodeIfPresent(Bool.self, forKey: .likes)
        
        author = try container.decode(String.self, forKey: .author)
        authorFlairCssClass = try container.decodeIfPresent(String.self, forKey: .authorFlairCssClass)
        authorFlairText = try container.decodeIfPresent(String.self, forKey: .authorFlairText)
        
        bannedBy = try container.decodeIfPresent(String.self, forKey: .bannedBy)

        body = try container.decode(String.self, forKey: .body)
        bodyHtml = try container.decode(String.self, forKey: .bodyHtml)

        if let editedInt = try? container.decodeIfPresent(Int.self, forKey: .edited) {
            edited = Date(timeIntervalSince1970: TimeInterval(editedInt))
        } else {
            // Boolean was provided for "edited"
            edited = nil
        }
        gilded = try container.decode(Int.self, forKey: .gilded)
        
        linkAuthor = try container.decodeIfPresent(String.self, forKey: .linkAuthor)
        linkId = try container.decode(String.self, forKey: .linkId)
        linkTitle = try container.decodeIfPresent(String.self, forKey: .linkTitle)
        linkUrl = try container.decodeIfPresent(String.self, forKey: .linkUrl)

        numReports = try container.decodeIfPresent(Int.self, forKey: .numReports)
        
        parentId = try container.decode(String.self, forKey: .parentId)

        if let repliesArray = try? container.decodeIfPresent(CommentListing.self, forKey: .replies) {
            replies = repliesArray
        } else {
            // Replies is the empty string
            replies = nil
        }

        saved = try container.decodeIfPresent(Bool.self, forKey: .saved)
        score = try container.decode(Int.self, forKey: .score)
        scoreHidden = try container.decode(Bool.self, forKey: .scoreHidden)
        
        subreddit = try container.decode(String.self, forKey: .subreddit)
        subredditId = try container.decode(String.self, forKey: .subredditId)
        distinguished = try container.decodeIfPresent(String.self, forKey: .distinguished)
    }
}
