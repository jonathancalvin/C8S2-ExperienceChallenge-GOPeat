//
//  CategoryFilter.swift
//  GOPeat
//
//  Created by jonathan calvin sutrisna on 29/03/25.
//

import SwiftUI

struct CategoryFilter: View {
    let categories: [String]
    let filterMode: FilterMode
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
    var rowCount: Int {
        (totalItem + column - 1) / column
    }
    
    @ViewBuilder
    func categoryView(for index: Int) -> some View {
        let category = categories[index]
        switch filterMode {
            case .dynamicCategories:
                CategoryToogleButton(name: category, isSelected: selectedCategories.contains(category)) {
                    if !selectedCategories.contains(category) {
                        if let conflict = conflictingCategory(for: category) {
                            selectedCategories.removeAll { $0 == conflict }
                        }
                        selectedCategories.append(category)
                    } else {
                        selectedCategories.removeAll { $0 == category }
                    }
                }
                
            case .fixCategories:
                FixCategoryButton(name: category) {
                    print("x")
                }
        default:
            EmptyView()
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
            VStack(alignment: .leading, spacing: 10) {
                ForEach(0..<rowCount, id: \.self) { i in
                    let lastRow = (rowCount - 1) == i
                    HStack(spacing: 10) {
                        ForEach(0..<column, id: \.self) { j in
                            let index = i * column + j
                            if index < categories.count {
                                categoryView(for: index)
                            } else {
                                Spacer()
                            }
                        }
                    }
                    if lastRow && filterMode == .fixCategories {
                        //TO DO: action for add button
                        AddButon(action: {
                            print("x")
                        })
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var selectedCategories: [String] = []
    var title: String = "Fix Categories"
    CategoryFilter(categories: ["Halal", "Non-Spicy", "Non-Greasy"], filterMode: FilterMode.fixCategories, selectedCategories: $selectedCategories, title: title, column: 3)
        .padding()
}
