//
//  Empty.swift
//  Reddit
//
//  Created by Adam Gastineau on 8/10/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import Foundation

struct Empty {
    
}

extension Empty: Decodable {
    init(from decoder: Decoder) throws {
        // Do nothing
    }
}
