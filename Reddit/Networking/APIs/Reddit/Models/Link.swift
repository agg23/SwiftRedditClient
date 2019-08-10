//
//  Link.swift
//  Reddit
//
//  Created by Adam Gastineau on 6/16/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import Foundation

struct Link: Thing, Created, Votable {
    enum LinkKeys: String, CodingKey {
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

        case clicked
        case domain
        case hidden
        case isSelf = "is_self"
        case linkFlairCssClass = "link_flair_css_class"
        case linkFlairText = "link_flair_text"
        case locked
        case media
        case mediaEmbed = "media_embed"
        case numComments = "num_comments"
        case nsfw = "over_18"
        case permalink
        case saved
        case score
        case selfText = "selftext"
        case selfTextHtml = "selftext_html"
        case subreddit
        case subredditId = "subreddit_id"
        case thumbnail
        case title
        case url
        case edited
        case distinguished
        case stickied
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
    
    // MARK: Link
    let author: String
    let authorFlairCssClass: String?
    let authorFlairText: String?

    let clicked: Bool
    let domain: String
    let hidden: Bool
    let isSelf: Bool

    let linkFlairCssClass: String?
    let linkFlairText: String?
    let locked: Bool
    let media: Any?
    let mediaEmbed: Any?
    let numComments: Int
    let nsfw: Bool
    let permalink: String
    let saved: Bool
    let score: Int
    let selfText: String
    let selfTextHtml: String?
    let subreddit: String
    let subredditId: String
    let thumbnail: String
    let title: String
    let url: String
    let edited: Date?
    let distinguished: String?
    let stickied: Bool
    
    public func isSelfPost(in subreddit: String) -> Bool {
        return domain.lowercased() == "self.\(subreddit.lowercased())"
    }
}

extension Link {
    /**
     Clones the provided Link, updating various user-specified values.
     Likes is intentially required, as it is ternary
    */
    init(original: Link, likes: Bool?, score: Int? = nil, saved: Bool? = nil, hidden: Bool? = nil) {
        let newScore = score ?? original.score
        let newSaved = saved ?? original.saved
        let newHidden = hidden ?? original.hidden
        
        self.init(id: original.id, name: original.name, kind: original.kind, created: original.created, createdUtc: original.createdUtc, ups: original.ups, downs: original.downs, likes: likes, author: original.author, authorFlairCssClass: original.authorFlairCssClass, authorFlairText: original.authorFlairText, clicked: original.clicked, domain: original.domain, hidden: newHidden, isSelf: original.isSelf, linkFlairCssClass: original.linkFlairCssClass, linkFlairText: original.linkFlairText, locked: original.locked, media: original.media, mediaEmbed: original.mediaEmbed, numComments: original.numComments, nsfw: original.nsfw, permalink: original.permalink, saved: newSaved, score: newScore, selfText: original.selfText, selfTextHtml: original.selfTextHtml, subreddit: original.subreddit, subredditId: original.subredditId, thumbnail: original.thumbnail, title: original.title, url: original.url, edited: original.edited, distinguished: original.distinguished, stickied: original.stickied)
    }
}

extension Link: Decodable {
    init(from decoder: Decoder) throws {
        let thingContainer = try decoder.container(keyedBy: ThingKeys.self)
        
        kind = try thingContainer.decode(String.self, forKey: .kind)
        
        let container = try thingContainer.nestedContainer(keyedBy: LinkKeys.self, forKey: ThingKeys.data)
        
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
        
        clicked = try container.decode(Bool.self, forKey: .clicked)
        domain = try container.decode(String.self, forKey: .domain)
        hidden = try container.decode(Bool.self, forKey: .hidden)
        isSelf = try container.decode(Bool.self, forKey: .isSelf)
        
        linkFlairCssClass = try container.decodeIfPresent(String.self, forKey: .linkFlairCssClass)
        linkFlairText = try container.decodeIfPresent(String.self, forKey: .linkFlairText)
        
        locked = try container.decode(Bool.self, forKey: .locked)
        media = nil
        mediaEmbed = nil
        numComments = try container.decode(Int.self, forKey: .numComments)
        nsfw = try container.decode(Bool.self, forKey: .nsfw)
        permalink = try container.decode(String.self, forKey: .permalink)
        saved = try container.decode(Bool.self, forKey: .saved)
        score = try container.decode(Int.self, forKey: .score)
        let selfTextString = try container.decode(String.self, forKey: .selfText)
        selfText = selfTextString.trimmingCharacters(in: .whitespacesAndNewlines)
        selfTextHtml = try container.decodeIfPresent(String.self, forKey: .selfTextHtml)
        subreddit = try container.decode(String.self, forKey: .subreddit)
        subredditId = try container.decode(String.self, forKey: .subredditId)
        thumbnail = try container.decode(String.self, forKey: .thumbnail)
        title = try container.decode(String.self, forKey: .title)
        url = try container.decode(String.self, forKey: .url)
        if let editedInt = try? container.decodeIfPresent(Int.self, forKey: .edited) {
            edited = Date(timeIntervalSince1970: TimeInterval(editedInt))
        } else {
            // Boolean was provided for "edited"
            edited = nil
        }
        distinguished = try container.decodeIfPresent(String.self, forKey: .distinguished)
        stickied = try container.decode(Bool.self, forKey: .stickied)
    }

}
