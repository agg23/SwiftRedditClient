//
//  RedditAPIManager.swift
//  Reddit
//
//  Created by Adam Gastineau on 6/16/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import Moya
import PromiseKit

struct RedditAPIManager {
    let provider = MoyaProvider<RedditAPITarget>()
    
    func getSubreddit() -> Void {
        firstly { () -> Promise<Listing<Link>> in
            provider.request(from: .getSubreddit("programming"))
        }.done { (data) in
            print(data)
        }
    }
}
