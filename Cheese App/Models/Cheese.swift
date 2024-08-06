//
//  Cheese.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/6/24.
//

import Foundation

struct Cheese: Decodable, Identifiable {
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
