//
//  CheeseReview.swift
//  Cheese App
//
//  Created by Josh Kotrous on 9/2/24.
//

import Foundation

struct CheeseReview: Codable, Identifiable {
    var id: String?
    var user_id: String
    var cheese_id: String
    var description: String
    var rating: Double
    
    init(id: String? = nil, user_id: String = "", cheese_id: String = "", description: String = "", rating: Double = 0.0) {
        self.id = id
        self.user_id = user_id
        self.cheese_id = cheese_id
        self.description = description
        self.rating = rating
    }
    
}
