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
        static let hasCompletedPreference = "hasCompletedPreference"
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
    var hasCompletedPreference: Bool {
        get { userDefaults.bool(forKey: Keys.hasCompletedPreference)}
        set { userDefaults.set(newValue, forKey: Keys.hasCompletedPreference)}
    }
    let foodCategories:[String] = CategoryType.food.categories
    let tenantCategories: [String] = CategoryType.tenant.categories
    let allCategories: [String] = CategoryType.food.categories + CategoryType.tenant.categories
    let allSortByOptions: [SortOption] = SortOption.allCases
}
