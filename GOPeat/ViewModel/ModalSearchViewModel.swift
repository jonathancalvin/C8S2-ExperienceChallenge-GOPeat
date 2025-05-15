//
//  ModalSearchViewModel.swift
//  GOPeat
//
//  Created by jonathan calvin sutrisna on 09/05/25.
//

import SwiftUI

final class ModalSearchViewModel: ObservableObject{
    @Published var searchTerm: String = ""
    @Published var sheeHeight: PresentationDetent = .fraction(0.1)
    @Published var filteredTenants: [Tenant] = []
    @Published var recentSearch: [String] = []
    @Published var selectedCategories: [String] = [] {
        didSet {
            updateFilteredTenant()
        }
    }
    @Published var maxPrice: Double? = 100000 {
        didSet {
            updateFilteredTenant()
        }
    }
    @Published var isOpenNow: Bool? = false {
        didSet {
            updateFilteredTenant()
        }
    }
    let tenants: [Tenant]
    let categories: [String] = AppStorageManager.shared.allCategories
    var selectedFoodCategories: [String] {
        get {
            return selectedCategories.filtered(by: AppStorageManager.shared.foodCategories)
        }
    }
    
    init(tenants: [Tenant]) {
        self.tenants = tenants
        self.filteredTenants = tenants
        self.selectedCategories = AppStorageManager.shared.fixCategories ?? []
    }
    func getDisplayFoods(tenant: Tenant, searchTerm: String) -> [Food] {
        let loweredCaseString = searchTerm.lowercased()
        
        let searchedFoods = tenant.foods.filter{ food in
            Set(selectedFoodCategories).isSubset(of: Set(food.categories.map {$0.rawValue}))
            && (searchTerm.isEmpty ? true : food.name.lowercased().contains(loweredCaseString))
        }
        return searchedFoods.isEmpty ? tenant.foods : searchedFoods
    }
    func doSearch(searchTerm: String) -> [Tenant] {
        guard !searchTerm.isEmpty else { return filteredTenants }
        let loweredCaseString = searchTerm.lowercased()
        return filteredTenants.filter { tenant in
            //Search by tenant name
            tenant.name.lowercased().contains(loweredCaseString) ||
            //Search by food name while considering filters
            tenant.foods.filter{food in
                Set(selectedFoodCategories).isSubset(of: Set(food.categories.map {$0.rawValue}))
            }.contains { food in
                food.name.lowercased().contains(loweredCaseString)
            }
        }
    }
    func isCurrentlyOpen(_ hours: String) -> Bool {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let now = timeFormatter.string(from: Date())
        let hoursRange = hours.split(separator: "-")
        guard hoursRange.count == 2 else { return false }
        let start = String(hoursRange[0])
        let end = String(hoursRange[1])
        return now >= start && now <= end
    }
    
    func updateFilteredTenant() {
        //Filter Tenant by Halal / Non-Halal
        let containsHalal = selectedCategories.contains("Halal")
        let containsNonHalal = selectedCategories.contains("Non-Halal")
        
        var halalTenants = tenants
        
        if containsHalal || containsNonHalal {
            halalTenants = halalTenants.filter { $0.isHalal == containsHalal }
        }
        filteredTenants = halalTenants.filter { tenant in
            let withinPriceRange = tenant.priceRange.split(separator: "-").compactMap { Double($0.replacingOccurrences(of: ".", with: "")) }
            let minPriceInRange = withinPriceRange.min() ?? 0
            let isPriceValid = minPriceInRange <= maxPrice ?? 100000
            let isOpen = !(isOpenNow ?? false) || isCurrentlyOpen(tenant.operationalHours)
            return isPriceValid && isOpen && (selectedFoodCategories.isEmpty || tenant.foods.contains { food in
                Set(selectedFoodCategories).isSubset(of: Set(food.categories.map { $0.rawValue }))
            })
        }
    }
    func saveRecentSearch(searchTerm: String) {
        recentSearch.removeAll { $0.lowercased() == searchTerm.lowercased() }
        recentSearch.insert(searchTerm, at: 0)
        if recentSearch.count > 5 {
            recentSearch = Array(recentSearch.prefix(5))
        }
    }
    func onClose() {
        sheeHeight = .fraction(0.1)
        searchTerm = ""
        selectedCategories = []
        filteredTenants = tenants
        isOpenNow = false
        maxPrice = 100000
    }
}
