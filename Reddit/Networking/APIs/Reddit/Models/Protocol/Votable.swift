//
//  Votable.swift
//  Reddit
//
//  Created by Adam Gastineau on 6/16/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import Foundation

protocol Votable: Decodable {
    var ups: Int { get }
    var downs: Int { get }
    /**
     If null, user has not voted on this item
    */
    var likes: Bool? { get }
}
