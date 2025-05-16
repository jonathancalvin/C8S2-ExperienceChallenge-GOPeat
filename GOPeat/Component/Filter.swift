//
//  Filter.swift
//  GOPeat
//
//  Created by jonathan calvin sutrisna on 29/03/25.
//

import SwiftUI

struct Filter: View {
    let categories: [String]
    @Binding var selectedCategories: [String]
    
    @State var showPriceFilter: Bool = false
    @State var showFoodFilter: Bool = false
    @State var showTenantFilter: Bool = false
    @State var showSortByFilter: Bool = false

    var isFilterUsed: Bool {
        return !(selectedCategories.isEmpty && (filterVM.sortBy == .none))
    }
    
    @EnvironmentObject var filterVM: FilterViewModel
    
    private var foodCategories: [String] {
        filterVM.selectedFoodCategories
    }
    private var tenantCategories: [String] {
        filterVM.selectedTenantCategories
    }
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
        HStack {
            // Reset All Category Button
            if isFilterUsed {
                Button {
                    filterVM.sortBy = .none
                    selectedCategories = []
                } label: {
                    Image(systemName: "x.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24)
                        .foregroundStyle(Color(.red))
                }
            }
            //More Filter Button
            Button {
                showPriceFilter = true
            } label: {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
                    .foregroundStyle(Color("Default"))
                    .opacity(isFilterUsed ? 1 : 0.3)
            }
            .sheet(isPresented: $showPriceFilter) {
                FilterSheetView(
                    tempSelectedCategories: filterVM.selectedCategories,
                    selectedOptionRaw: filterVM.sortBy.rawValue
                )
                .environmentObject(filterVM)
            }
            ScrollViewReader { scrollProxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        FilterButton(name: "Food", isSelected: !foodCategories.isEmpty, action: {
                            showFoodFilter = true
                        })
                        .sheet(isPresented: $showFoodFilter) {
                            FoodFilterView(selectedCategories: $selectedCategories, present: $showFoodFilter)
                                .presentationDetents([.fraction(0.3)])
                                .presentationDragIndicator(.visible)
                        }
                        
                        FilterButton(name: "Tenant", isSelected:!tenantCategories.isEmpty, action: {
                            showTenantFilter = true
                        })
                        .sheet(isPresented: $showTenantFilter) {
                            TenantFilterView(selectedCategories: $selectedCategories, present: $showTenantFilter)
                                .presentationDetents([.fraction(0.25)])
                                .presentationDragIndicator(.visible)
                        }
                        
                        FilterButton(name: "Sort By", isSelected: filterVM.sortBy != .none, action: {
                            showSortByFilter = true
                        })
                        .sheet(isPresented: $showSortByFilter) {
                            SortByView(sortBy: $filterVM.sortBy, present: $showSortByFilter)
                                .presentationDetents([.fraction(0.42)])
                                .presentationDragIndicator(.visible)
                        }
                        
                    }
                }
                .onChange(of: selectedCategories, initial: selectedCategories.isEmpty) { _, _ in
                    withAnimation {
                        scrollProxy.scrollTo("scrollStart", anchor: .leading)
                    }
                }
            }.frame(maxHeight: 50)
        }
    }
}
