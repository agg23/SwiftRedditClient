//
//  APIUtilities.swift
//  Reddit
//
//  Created by Adam Gastineau on 6/17/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import Foundation
import Moya
import PromiseKit

extension MoyaProvider {
    func request<R: Decodable>(from target: Target) -> Promise<R> {
        return Promise<R> { (resolver) in
            self.request(target, completion: { (result) in
                switch result {
                case let .success(response):
                    do {
                        let objectResponse = try response.map(R.self)
                        resolver.fulfill(objectResponse)
                    } catch {
                        print("Error")
                        print(response)
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
