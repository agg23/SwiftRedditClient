//
//  Created.swift
//  Reddit
//
//  Created by Adam Gastineau on 6/16/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import Foundation

enum CreatedKeys: String, CodingKey {
    case created = "created"
    case created_utc = "created_utc"
}

protocol Created: Decodable {
    var created: Int { get }
    var createdUtc: Int { get }
}
