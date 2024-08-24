//
//  Cheese.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/6/24.
//

import Foundation

struct Cheese: Codable, Identifiable {
    var id: String
    var name: String
    var category: String
    var url: String?
    var description: String
    var notes: String?
    var allergens: String?
    var ingredients: String?
    var additionalFacts: String?
    var community_added: Bool?
    var user_id: String?

    init(id: String = "", name: String = "", category: String = "", url: String? = nil, description: String = "", notes: String? = nil, allergens: String? = nil, ingredients: String? = nil, additionalFacts: String? = nil, community_added: Bool? = nil, user_id: String? = nil) {
        self.id = id
        self.name = name
        self.category = category
        self.url = url
        self.description = description
        self.notes = notes
        self.allergens = allergens
        self.ingredients = ingredients
        self.additionalFacts = additionalFacts
        self.community_added = community_added
        self.user_id = user_id
    }
}


struct Category: Decodable, Identifiable {
    let id: Int
    let category: String
}

struct Gateway: Decodable, Identifiable {
    let id: Int
    let gateway: String
}
