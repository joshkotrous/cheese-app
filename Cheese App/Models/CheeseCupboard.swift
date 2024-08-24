//
//  CheeseCupboard.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/22/24.
//

import Foundation

struct CheeseCupboard: Codable, Identifiable {
    var id: String
    var cheese_id: String
    var cupboard_id: String
    init(id: String = "", cheese_id: String = "", cupboard_id: String = ""){
        self.id = id
        self.cheese_id = cheese_id
        self.cupboard_id = cupboard_id
    }
}
