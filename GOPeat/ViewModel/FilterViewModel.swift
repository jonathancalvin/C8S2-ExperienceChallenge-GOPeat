//
//  FilterViewModel.swift
//  GOPeat
//
//  Created by jonathan calvin sutrisna on 15/05/25.
//

import SwiftUI

final class FilterViewModel: ObservableObject {
    @Published var selectedCategories: [String] = AppStorageManager.shared.fixCategories ?? []
    @Published var sortBy: SortOption = .none
    var selectedFoodCategories: [String] {
        get {
            return selectedCategories.filtered(by: AppStorageManager.shared.foodCategories)
        }
    }
    var selectedTenantCategories: [String] {
        get {
            return selectedCategories.filtered(by: AppStorageManager.shared.tenantCategories)
        }
    }
    
}
