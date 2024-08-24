//
//  Cheese.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/6/24.
//

import Foundation

struct Cheese: Codable, Identifiable {
    var id: String?
    var name: String?
    var category: String?
    var url: String?
    var description: String?
    var notes: String?
    var allergens: String?
    var ingredients: String?
    var additionalFacts: String?
    var community_added: Bool?
    var user_id: String?

}


struct Category: Decodable, Identifiable {
    let id: Int?
    let category: String
}

struct Gateway: Decodable, Identifiable {
    let id: Int?
    let gateway: String
}
