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
//    @Binding var maxPrice: Double?
//    @Binding var isOpenNow: Bool?
    
//    @State var showPriceFilter: Bool = false
//    @State var isAdditionalFilterUsed: Bool = false
    
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
    
//    private func updateIsAdditionalFilterUsed(maxPrice: Double?, isOpenNow: Bool?) {
//        var isMapPriceChanged = false
//        var isOpenNowChanged = false
//        if let _ = maxPrice {
//            isMapPriceChanged = maxPrice != 100000
//        }
//        if let _ = isOpenNow {
//            isOpenNowChanged = isOpenNow == true
//        }
//        isAdditionalFilterUsed = isMapPriceChanged || isOpenNowChanged
//    }

    var body: some View {
        VStack(alignment: .leading) {
//            HStack {
//                // Reset All Category Button
//                if isAdditionalFilterUsed || !selectedCategories.isEmpty {
//                    Button {
//                        if let _ = maxPrice {
//                            maxPrice = 100000
//                        }
//                        if let _ = isOpenNow {
//                            isOpenNow = false
//                        }
//                        selectedCategories = []
//                    } label: {
//                        Image(systemName: "x.circle")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 20)
//                            .foregroundStyle(Color(.red))
//                    }
//                }
//                //More Filter Button
//                if let _ = maxPrice,
//                   let _ = isOpenNow {
//                    Button {
//                        showPriceFilter = true
//                    } label: {
//                        Image(systemName: "line.3.horizontal.decrease.circle")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 20)
//                            .foregroundStyle(Color("Default"))
//                            .opacity(isAdditionalFilterUsed ? 1 : 0.3)
//                    }
//                    .onChange(of: maxPrice) { _, _ in
//                        updateIsAdditionalFilterUsed(maxPrice: maxPrice, isOpenNow: nil)
//                    }
//                    .onChange(of: isOpenNow) { _, _ in
//                        updateIsAdditionalFilterUsed(maxPrice: nil, isOpenNow: isOpenNow)
//                    }
//                    .sheet(isPresented: $showPriceFilter) {
//                        MoreFilterView(
//                            maxPrice: Binding(get: { maxPrice ?? 100000 }, set: { maxPrice = $0 }),
//                            isOpenNow: Binding(get: { isOpenNow ?? false }, set: { isOpenNow = $0 })
//                        )
//                    }
//                }
//            }
                        
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
//            ScrollViewReader { scrollProxy in
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack(spacing: 0) {
//                        Color.clear
//                            .frame(width: 0)
//                            .id("scrollStart")
//
//                        HStack(spacing: 10) {
//                            ForEach(categories.sorted { lhs, rhs in
//                                let lhsSelected = selectedCategories.contains(lhs)
//                                let rhsSelected = selectedCategories.contains(rhs)
//                                return lhsSelected && !rhsSelected
//                            }, id: \.self) { category in
//                                Button {
//                                    if !selectedCategories.contains(category) {
//                                        if let conflictCategory = conflictingCategory(for: category) {
//                                            selectedCategories.removeAll { $0 == conflictCategory }
//                                        }
//                                        selectedCategories.append(category)
//                                    } else {
//                                        selectedCategories.removeAll { $0 == category }
//                                    }
//                                } label: {
//                                                            CategoryToogleButton(name: category, isSelected: selectedCategories.contains(category))
//                            }
//                        }
//                    }
//                }
//                .onChange(of: selectedCategories, initial: selectedCategories.isEmpty) { _, _ in
//                    withAnimation {
//                        scrollProxy.scrollTo("scrollStart", anchor: .leading)
//                    }
//                }
//            }.frame(maxHeight: 50)
        }
    }
}

#Preview {
    @Previewable @State var selectedCategories: [String] = []
//    @Previewable @State var maxPrice: Double? = nil
//    @Previewable @State var isOpenNow: Bool? = nil
    CategoryFilter(categories: Food.allCategories, selectedCategories: $selectedCategories)
}
