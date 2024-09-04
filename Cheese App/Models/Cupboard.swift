//
//  Cupboard.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/21/24.
//

import Foundation


struct Cupboard: Decodable, Encodable, Identifiable {
    var id: String?
    var name: String?
    var profile_id: String?
    let cupboard_cheese: [CheeseReviewCount]?

    init(id: String? = nil, name: String? = nil, profile_id: String? = nil, cupboard_cheese: [CheeseReviewCount]? = nil) {
        self.cupboard_cheese = cupboard_cheese
        self.id = id
        self.name = name
        self.profile_id = profile_id
    }
}

struct CheeseReviewCount: Decodable, Encodable {
    let count: Int
}


