//
//  CategoryFilter.swift
//  GOPeat
//
//  Created by jonathan calvin sutrisna on 29/03/25.
//

import SwiftUI

struct CategoryFilter: View {
    let categories: [String]
    @Binding var selectedCategories: [String]
    // Function to return conflicting category
    private func conflictingCategory(for category: String) -> String? {
        if category.hasPrefix("Non-") {
            // If start with "Non-", check category without "Non-"
            let conflictCategory = String(category.dropFirst(4))
            return selectedCategories.contains(conflictCategory) ? conflictCategory : nil
        } else {
            // If start without "Non-", check category with "Non-"
            let conflictCategory = "Non-" + category
            return selectedCategories.contains(conflictCategory) ? conflictCategory : nil
        }
    }
    let title: String
    var totalItem: Int{
        get {
            return categories.count
        }
    }
    let column: Int
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
            VStack(alignment: .leading, spacing: 10) {
                ForEach(0..<((totalItem + column - 1) / column), id: \.self) { i in
                    HStack(spacing: 10) {
                        ForEach(0..<column, id: \.self) { j in
                            let index = i * column + j
                            if index < categories.count {
                                let category = categories[index]
                                
                                    CategoryToogleButton(name: category, isSelected: selectedCategories.contains(category),
                                                         action: {
                                        if !selectedCategories.contains(category) {
                                            if let conflictCategory = conflictingCategory(for: category) {
                                                selectedCategories.removeAll { $0 == conflictCategory }
                                            }
                                            selectedCategories.append(category)
                                        } else {
                                            selectedCategories.removeAll { $0 == category }
                                        }
                                    })
                            } else {
                                Spacer()
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var selectedCategories: [String] = []
    var title: String = "Cuisine Type"
    CategoryFilter(categories: AppStorageManager.shared.foodCategories, selectedCategories: $selectedCategories, title: title, column: 4)
}
