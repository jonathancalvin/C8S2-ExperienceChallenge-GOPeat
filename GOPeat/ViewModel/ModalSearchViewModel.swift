//
//  ModalSearchViewModel.swift
//  GOPeat
//
//  Created by jonathan calvin sutrisna on 09/05/25.
//

import SwiftUI
import Combine
final class ModalSearchViewModel: ObservableObject{
    @Published var searchTerm: String = ""
    @Published var sheeHeight: PresentationDetent = .fraction(0.1)
    @Published var filteredTenants: [Tenant] = []
    @Published var recentSearch: [String] = []
    private var cancellables = Set<AnyCancellable>()
    private let filterVM: FilterViewModel
    let tenants: [Tenant]
    let categories: [String] = AppStorageManager.shared.allCategories
    var selectedFoodCategories: [String] {
        filterVM.selectedFoodCategories
    }
    
    init(tenants: [Tenant], filterVM: FilterViewModel) {
        self.tenants = tenants
        self.filteredTenants = tenants
        self.filterVM = filterVM
        addSubscribers()
    }
    private func addSubscribers() {
        Publishers.CombineLatest3(filterVM.$selectedCategories, filterVM.$sortBy, filterVM.$selectedPriceRanges)
            .dropFirst()
            .debounce(for: .nanoseconds(1), scheduler: RunLoop.main)
            .sink { [weak self] _, _, _ in
                guard let self = self else {return}
                self.updateFilteredTenant()
            }
            .store(in: &cancellables)

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
        for category in filterVM.selectedCategories {
            print(category)
        }
        let containsHalal = filterVM.selectedCategories.contains("Halal")
        let containsNonHalal = filterVM.selectedCategories.contains("Non-Halal")
        
        var halalTenants = tenants
        
        if containsHalal || containsNonHalal {
            halalTenants = halalTenants.filter { $0.isHalal == containsHalal }
        }
        filteredTenants = halalTenants.filter { tenant in
            let isOpen = !(filterVM.selectedTenantCategories.contains {$0 == "Open Now"}) || isCurrentlyOpen(tenant.operationalHours)
            let price = PriceUtil.getMinPrice(from: tenant.priceRange)
            let priceRangeOption = PriceUtil.getPriceRangeOption(for: price)
            let isPriceValid = filterVM.selectedPriceRanges.contains(priceRangeOption)
            
            return isOpen && isPriceValid && (selectedFoodCategories.isEmpty || tenant.foods.contains { food in
                Set(selectedFoodCategories).isSubset(of: Set(food.categories.map { $0.rawValue }))
            })
        }
        filteredTenants.sort(using: filterVM.sortBy.tenantSortClosure)
        for tenant in filteredTenants {
            tenant.foods.sort(using: filterVM.sortBy.foodSortClosure)
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
        filterVM.selectedCategories = AppStorageManager.shared.fixCategories ?? []
        filteredTenants = tenants
    }
}
