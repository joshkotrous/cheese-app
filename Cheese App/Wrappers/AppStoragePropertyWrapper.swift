//
//  AppStoragePropertyWrapper.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/22/24.
//

import Foundation
import SwiftUI

@propertyWrapper
struct AppStorageCodable<T: Codable>: DynamicProperty {
    @AppStorage private var data: Data?
    
    private let defaultValue: T
    
    var wrappedValue: T {
        get {
            if let data = data {
                let decoder = JSONDecoder()
                return (try? decoder.decode(T.self, from: data)) ?? defaultValue
            } else {
                return defaultValue
            }
        }
        set {
            let encoder = JSONEncoder()
            data = try? encoder.encode(newValue)
        }
    }
    
    init(wrappedValue defaultValue: T, _ key: String) {
        self.defaultValue = defaultValue
        self._data = AppStorage(key)
    }
}
