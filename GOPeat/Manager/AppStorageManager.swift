//
//  AppStorageManager.swift
//  GOPeat
//
//  Created by jonathan calvin sutrisna on 12/05/25.
//

import Foundation

final class AppStorageManager {
    static let shared = AppStorageManager()
    private let userDefaults = UserDefaults.standard
    
    private init() {}
    
    private enum Keys {
        static let fixCategories = "fixCategories"
    }
    
    var fixCategories: [String]? {
        get {
            guard let data = userDefaults.data(forKey: Keys.fixCategories) else { return nil }
            return try? JSONDecoder().decode([String].self, from: data)
        }
        set {
            if let newValue = newValue {
                let encoded = try? JSONEncoder().encode(newValue)
                userDefaults.set(encoded, forKey: Keys.fixCategories)
            } else {
                userDefaults.removeObject(forKey: Keys.fixCategories)
            }
        }
    }
}
