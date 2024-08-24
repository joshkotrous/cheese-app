//
//  UserCheese.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/23/24.
//

import Foundation

struct UserCheese: Codable, Identifiable {
    var id: String?
    var name: String?
    var description: String?
    var category: String?
    var user_id: String?
}
