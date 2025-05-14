//
//  Filter.swift
//  GOPeat
//
//  Created by jonathan calvin sutrisna on 29/03/25.
//

import SwiftUI

struct CategoryFilter: View {
    let categories: [String]
    let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 85))
    ]
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

    var body: some View {
        VStack(alignment: .leading) {
            LazyVGrid(columns: columns, alignment: .leading, spacing: 10) {
                ForEach(categories, id: \.self) { category in
                    Button {
                        if !selectedCategories.contains(category) {
                            if let conflictCategory = conflictingCategory(for: category) {
                                selectedCategories.removeAll { $0 == conflictCategory }
                            }
                            selectedCategories.append(category)
                        } else {
                            selectedCategories.removeAll { $0 == category }
                        }
                    } label: {
                        CategoryToogleButton(name: category, isSelected: selectedCategories.contains(category))
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var selectedCategories: [String] = []
    CategoryFilter(categories: Food.allCategories, selectedCategories: $selectedCategories)
}
