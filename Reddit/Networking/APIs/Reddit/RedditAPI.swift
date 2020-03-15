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
    
    var shouldAuthenticate = false
    weak var authenticationWindow: NSWindow?
    
    let sessionManager: Session
    let oAuth = OAuthManager.shared.redditOAuth
    
    let oAuthUrl = URL(string: "https://oauth.reddit.com")!
    
    init() {
        let retrier = OAuthRetryHandler(oauth2: oAuth)
        sessionManager = Session(interceptor: retrier)
        super.init(session: sessionManager)
    }
    
    override func endpoint(_ target: RedditAPITarget) -> Endpoint {
        let url: URL
        
        if shouldAuthenticate {
            url = !target.path.isEmpty ? oAuthUrl.appendingPathComponent(target.path) : oAuthUrl
        } else {
            url = URL(target: target)
        }
        
        return Endpoint(url: url.absoluteString, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, task: target.task, httpHeaderFields: target.headers)
    }
    
    func authenticate(with contextWindow: NSWindow?) -> Promise<Void> {
        return Promise<Void> { (resolver) in
            oAuth.authConfig.authorizeEmbedded = true
            oAuth.authConfig.authorizeContext = contextWindow
            oAuth.authorize(params: ["duration": "permanent"]) { (json, error) in
                debugPrint("auth: json:\(String(describing: json)). error: \(String(describing: error))")
                resolver.resolve(error)
            }
            
            oAuth.logger = OAuth2DebugLogger(.trace)
        }
    }
    
    func request<R: Decodable>(from target: Target, with contextWindow: NSWindow? = nil) -> Promise<R> {
        print(target.path)
        
        let window = contextWindow != nil ? contextWindow : authenticationWindow
        
        if shouldAuthenticate {
            return authenticate(with: window).then { () -> Promise<R> in self.buildRequestPromise(from: target)}
        }
        
        return buildRequestPromise(from: target)
    }

    private func buildRequestPromise<R: Decodable>(from target: Target) -> Promise<R> {
        return Promise<R> { (resolver) in
            print("Resolving \(target)")
            self.request(target, completion: { (result) in
                switch result {
                case let .success(response):
                    do {
                        let objectResponse = try response.map(R.self)
                        resolver.fulfill(objectResponse)
                    } catch {
                        print("Error")
                        print(response)
                        print(try! response.mapString())
                        resolver.reject(error)
                    }
                case let .failure(error):
                    print("Error")
                    resolver.reject(error)
                }
            })
        }
    }
}
