//
//  RedditAPI.swift
//  Reddit
//
//  Created by Adam Gastineau on 6/19/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import AppKit
import OAuth2
import Moya
import Alamofire
import PromiseKit

class RedditAPI: MoyaProvider<RedditAPITarget> {
    static let shared = RedditAPI()
    
    let sessionManager: SessionManager
    let oAuth = OAuthManager.shared.redditOAuth
    
    init() {
        sessionManager = SessionManager()
        super.init(manager: sessionManager)

        let retrier = OAuthRetryHandler(oauth2: oAuth)
        sessionManager.adapter = retrier
        sessionManager.retrier = retrier
    }
    
    func authenticate(with contextWindow: NSWindow?) -> Promise<Void> {
        let promise = Promise<Void> { (resolver) in
            oAuth.authConfig.authorizeEmbedded = true
            oAuth.authConfig.authorizeContext = contextWindow
            oAuth.authorize(params: nil) { (json, error) in
                debugPrint("auth: json:\(String(describing: json)). error: \(String(describing: error))")
                resolver.resolve(error)
            }
            
            oAuth.logger = OAuth2DebugLogger(.trace)
        }
        
        return promise
    }
}
