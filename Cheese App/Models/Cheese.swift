//
//  Cheese.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/6/24.
//

import Foundation

struct Cheese: Codable, Identifiable {
    let id: String?
    let name: String?
    let category: String?
    let url: String?
    let description: String?
    let notes: String?
    let allergens: String?
    let ingredients: String?
    let additionalFacts: String?

}


struct Category: Decodable, Identifiable {
    let id: Int?
    let category: String
}

struct Gateway: Decodable, Identifiable {
    let id: Int?
    let gateway: String
}
