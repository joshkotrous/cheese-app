//
//  AppConfig.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/23/24.
//

import Foundation
import SwiftUI

struct AppConfig {
    static let fontName = "IowanOldStyle-Roman"
    static let createByMe = "Created By Me"
    static let eaten = "Eaten"
    static let inTheFridge = "In the Fridge"
    static let wantToEat = "Want to Eat"
    static let reviewedByMe = "Reviewed By Me"
    static let defaultCupboards = [AppConfig.createByMe, AppConfig.eaten, AppConfig.inTheFridge, AppConfig.wantToEat, AppConfig.reviewedByMe]
}
