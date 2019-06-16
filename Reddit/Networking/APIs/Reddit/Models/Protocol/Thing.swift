//
//  Thing.swift
//  Reddit
//
//  Created by Adam Gastineau on 6/16/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import Foundation

enum ThingKeys: String, CodingKey {
    case kind
    case data
}

protocol Thing: Decodable {
    var id: String { get }
    var name: String { get }
    var kind: String { get }
}
