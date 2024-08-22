//
//  CupboardCheeseList.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/22/24.
//

import Foundation

struct CupboardCheeseList: Codable, Identifiable {
    let id: String
    var cheese: Cheese?

    enum CodingKeys: String, CodingKey {
      case id, cheese
    }
}
