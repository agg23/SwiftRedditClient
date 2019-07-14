//
//  RedditAPI.swift
//  Reddit
//
//  Created by Adam Gastineau on 6/16/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import Moya

enum RedditAPITarget {
    case subreddit(_: String, type: RedditAPISubredditType, size: Int?, after: String?, previousResults: Int?)
    case comments(in: String, on: String)
    case moreComments(link: String, childrenIds: [String])
    case messages
}

enum RedditAPISubredditType {
    case hot
    case new
    case rising
    case top(_: RedditAPISubredditTimeInterval)
    case controversial(_: RedditAPISubredditTimeInterval)
    case gilded
}

enum RedditAPISubredditTimeInterval: String {
    case hour
    case day
    case week
    case month
    case year
    case all
}

extension RedditAPITarget: TargetType {
    func buildParamters(from parameters: [String: String?]) -> [String: String] {
        return parameters.compactMapValues { $0 }
    }
    
    var baseURL: URL {
        guard requiresOAuth else {
            return URL(string: "https://www.reddit.com")!
        }

        return URL(string: "https://oauth.reddit.com")!
    }
    
    var path: String {
        switch self {
        case .subreddit(let subreddit, let type, _, _, _):
            var typeString = "\(type)"
            
            switch type {
            case .top(_):
                typeString = "top"
                break
            case .controversial(_):
                typeString = "controversial"
                break
            default:
                break
            }
            return "/r/\(subreddit)/\(typeString).json"
        case .comments(let subreddit, let link):
            return "/r/\(subreddit)/comments/\(link).json"
        case .moreComments(_):
            return "/api/morechildren.json"
        case .messages:
            return "/message/inbox.json"
        }
    }
    
    var method: Method {
        switch self {
        case .subreddit(_):
            return .get
        case .comments(_):
            return .get
        case .moreComments(_):
            return .get
        case .messages:
            return .get
        }
    }
    
    var sampleData: Data {
        return "empty".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .subreddit(_, let type, let size, let after, let previousResults):
            let limit = size ?? 50
            
            var fetchInterval: RedditAPISubredditTimeInterval?
            
            switch type {
            case .top(let interval), .controversial(let interval):
                fetchInterval = interval
            default:
                break
            }
            
            let parameters = buildParamters(from:
                                ["limit": String(describing: limit),
                                 "count": String(describing: previousResults),
                                 "after": after,
                                 "t": fetchInterval?.rawValue])
            
            if parameters.count < 1 {
                return .requestPlain
            }
            
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .comments(_):
            return .requestPlain
        case .moreComments(let link, let childrenIds):
            let parameters = [
                "api_type": "json",
                "link_id": link,
                "children": childrenIds.joined(separator: ",")
            ]
            
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .messages:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return [:]
    }
    
    var requiresOAuth: Bool {
        switch self {
        case .messages:
            return true
        default:
            return false
        }
    }
}
