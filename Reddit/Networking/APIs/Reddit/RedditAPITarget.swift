//
//  RedditAPI.swift
//  Reddit
//
//  Created by Adam Gastineau on 6/16/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import Moya

enum RedditAPITarget {
    case getSubreddit(_: String)
}

extension RedditAPITarget: TargetType {
    var baseURL: URL {
        return URL(string: "https://www.reddit.com")!
    }
    
    var path: String {
        switch self {
        case .getSubreddit(let subreddit):
            return "/r/\(subreddit)/new.json"
        }
    }
    
    var method: Method {
        switch self {
        case .getSubreddit(_):
            return .get
        }
    }
    
    var sampleData: Data {
        return "empty".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .getSubreddit(_):
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return [:]
    }
}
