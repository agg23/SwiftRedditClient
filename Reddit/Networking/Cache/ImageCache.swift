//
//  ImageCache.swift
//  Reddit
//
//  Created by Adam Gastineau on 8/18/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import Cocoa
import Alamofire

class ImageCache {
    static let shared = ImageCache()
    
    var cache: [String: ImageFetchResult] = [:]
    
    func image(for urlString: String, completionHandler: @escaping (Result<ImageFetchResult, Error>) -> Void) {
        let cachedResult = cache[urlString]
        
        if let cachedResult = cachedResult {
            completionHandler(.success(cachedResult))
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        AF.request(url).response { response in
            guard let imageData = response.data else {
                completionHandler(.failure(FetchError.imageRetrivalError))
                return
            }
            
            let decodedImage = NSImage(data: imageData)
            
            guard let image = decodedImage else {
                completionHandler(.failure(FetchError.imageDecodingError))
                return
            }
            
            let result = ImageFetchResult(url: url, image: image, owningId: nil)
            self.cache[urlString] = result
            completionHandler(.success(result))
        }
    }
}
