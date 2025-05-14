//
//  TenantViewModel.swift
//  GOPeat
//
//  Created by jonathan calvin sutrisna on 12/05/25.
//

import SwiftUI

class TenantViewModel: ObservableObject{
    @Published var filteredFoods: [Food] = []
    
    let foods: [Food]
    let categories: [String] = FoodCategory.allCases.map{ $0.rawValue }
    
    init(foods: [Food]) {
        var tempfoods = foods
        let dummy = Food(name: "Dumy", description: "Dumy", categories: [.nonSpicy, .nonGreasy, .nonSweet, .spicy, .greasy, .sweet, .soup, .roast, .savory], tenant: nil, price: 15000, image: "defaultFood")
        tempfoods.insert(dummy, at: 0)
        self.foods = tempfoods
        self.filteredFoods = tempfoods
    }
    
    func updateFilteredFood(selectedCategories: [String]) {
        if selectedCategories.isEmpty {
            filteredFoods = foods
        } else {
            filteredFoods = foods.filter { food in
                Set(selectedCategories).isSubset(of: Set(food.categories.map { $0.rawValue }))
            }
        }
    }
}
