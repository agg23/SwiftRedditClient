//
//  RedditAPI.swift
//  Reddit
//
//  Created by Adam Gastineau on 6/16/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import Moya

enum RedditAPITarget {
    case subreddit(_: String, type: RedditAPISubredditType)
    case comments(in: String, on: String)
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
    var baseURL: URL {
        guard requiresOAuth else {
            return URL(string: "https://messages.reddit.com")!
        }

        return URL(string: "https://oauth.reddit.com")!
    }
    
    var path: String {
        switch self {
        case .subreddit(let subreddit, let type):
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
        case .messages:
            return .get
        }
    }
    
    var sampleData: Data {
        return "empty".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .subreddit(_, let type):
            switch type {
            case .top(let interval), .controversial(let interval):
                return .requestParameters(parameters: ["t": interval.rawValue], encoding: URLEncoding.default)
            default:
                return .requestPlain
            }
        case .comments(_):
            return .requestPlain
        case .messages:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return [:]
    }
    
    var requiresOAuth: Bool {
        switch self {
        case .comments(_):
            return true
        case .messages:
            return true
        default:
            return false
        }
    }
}
