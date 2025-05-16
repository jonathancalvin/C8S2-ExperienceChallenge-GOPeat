//
//  TenantViewModel.swift
//  GOPeat
//
//  Created by jonathan calvin sutrisna on 12/05/25.
//

import SwiftUI
import Combine
class TenantViewModel: ObservableObject{
    @Published var filteredFoods: [Food] = []
    
    let foods: [Food]
    let categories: [String] = FoodCategory.allCases.map{ $0.rawValue }
    
    private let filterVM: FilterViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(foods: [Food], filterVM: FilterViewModel) {
        var tempfoods = foods
        let dummy = Food(name: "Dumy", description: "Dumy", categories: [.nonSpicy, .nonGreasy, .nonSweet, .spicy, .greasy, .sweet, .soup, .roast, .savory], tenant: nil, price: 15000, image: "defaultFood")
        tempfoods.insert(dummy, at: 0)
        self.foods = tempfoods
        self.filteredFoods = tempfoods
        self.filterVM = filterVM
        addSubscribers()
    }
    
    private func addSubscribers() {
        Publishers.CombineLatest(filterVM.$selectedCategories, filterVM.$sortBy)
            .debounce(for: .nanoseconds(1), scheduler: RunLoop.main)
            .sink { [weak self] _,_ in
                guard let self = self else {return}
                self.updateFilteredFood(selectedCategories: filterVM.selectedFoodCategories)
            }
            .store(in: &cancellables)
    }
    
    func updateFilteredFood(selectedCategories: [String]) {
        if selectedCategories.isEmpty {
            filteredFoods = foods
        } else {
            filteredFoods = foods.filter { food in
                Set(selectedCategories).isSubset(of: Set(food.categories.map { $0.rawValue }))
            }
        }
        filteredFoods.sort(using: filterVM.sortBy.foodSortClosure)
    }
}
