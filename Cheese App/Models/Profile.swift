//
//  Profile.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/21/24.
//

import Foundation

struct Profile: Codable, Identifiable {
    var user_id: String
    var id: String?
    var bio: String?
    var username: String?

}
