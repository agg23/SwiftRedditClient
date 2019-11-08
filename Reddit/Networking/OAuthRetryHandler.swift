//
//  OAuthRetryHandler.swift
//  Reddit
//
//  Created by Adam Gastineau on 6/19/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import OAuth2
import Alamofire

// Taken from https://learnandbuild.net/2018/10/03/coinbase-api/
class OAuthRetryHandler: RequestInterceptor {
    let loader: OAuth2DataLoader
    
    init(oauth2: OAuth2) {
        loader = OAuth2DataLoader(oauth2: oauth2)
    }
    
    /// Intercept 401 and do an OAuth2 authorization.
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        if let response = request.task?.response as? HTTPURLResponse, 401 == response.statusCode, let req = request.request {
            var dataRequest = OAuth2DataRequest(request: req, callback: { _ in })
            
            dataRequest.context = completion
            loader.enqueue(request: dataRequest)
            loader.attemptToAuthorize() { authParams, error in
                self.loader.dequeueAndApply() { req in
                    if let comp = req.context as? (RetryResult) -> Void {
                        comp(authParams != nil ? .retry : .doNotRetry)
                    }
                }
            }
        }
        else {
            completion(.doNotRetry)   // not a 401, not our problem
        }
    }
    
    /// Sign the request with the access token.
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard nil != loader.oauth2.accessToken else {
            return completion(.success(urlRequest))
        }
        
        do {
            return try completion(.success(urlRequest.signed(with: loader.oauth2)))
        } catch {
            return completion(.failure(error))
        }
    }
}
