//
//  Filter.swift
//  GOPeat
//
//  Created by jonathan calvin sutrisna on 29/03/25.
//

import SwiftUI

struct Filter: View {
    let categories: [String]
    let filterMode: FilterMode
    
    @State var showFilterSheet: Bool = false
    @State var showFoodFilter: Bool = false
    @State var showTenantFilter: Bool = false
    @State var showSortByFilter: Bool = false
    @State var showPriceRangeFilter: Bool = false
    
    
    @EnvironmentObject var filterVM: FilterViewModel
    init(categories: [String], filterMode: FilterMode) {
        self.categories = categories
        self.filterMode = filterMode
    }
    
    private var selectedCategories: Binding<[String]> {
        Binding(
            get: {filterVM.selectedCategories},
            set: {filterVM.selectedCategories = $0}
        )
    }
    private var selectedPriceRange: Binding<[PriceRangeOption]> {
        Binding(
            get: { filterVM.selectedPriceRanges },
            set: { filterVM.selectedPriceRanges = $0 }
        )
    }
    
    private var sortByOptions: [SortOption] {
        get {
            if filterMode == .tenantView {
                return [SortOption.premiumPrice, SortOption.affordablePrice]
            }
            return AppStorageManager.shared.allSortByOptions
        }
    }
    private var priceRangeOptions: [PriceRangeOption] {
        AppStorageManager.shared.allPriceRangeOptions
    }
    
    private var foodCategories: [String] {
        filterVM.selectedFoodCategories
    }
    private var tenantCategories: [String] {
        filterVM.selectedTenantCategories
    }
    
    var isFilterUsed: Bool {
        return !(selectedCategories.isEmpty && (filterVM.sortBy == .none))
    }
    
    // Function to return conflicting category
    
    private func conflictingCategory(for category: String) -> String? {
        if category.hasPrefix("Non-") {
            // If start with "Non-", check category without "Non-"
            let conflictCategory = String(category.dropFirst(4))
            return selectedCategories.wrappedValue.contains(conflictCategory) ? conflictCategory : nil
        } else {
            // If start without "Non-", check category with "Non-"
            let conflictCategory = "Non-" + category
            return selectedCategories.wrappedValue.contains(conflictCategory) ? conflictCategory : nil
        }
    }
    var body: some View {
        HStack {
            // Reset All Category Button
            if isFilterUsed {
                Button {
                    filterVM.sortBy = .none
                    selectedCategories.wrappedValue = []
                    selectedPriceRange.wrappedValue = AppStorageManager.shared.allPriceRangeOptions
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
                showFilterSheet = true
            } label: {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
                    .foregroundStyle(Color("Default"))
                    .opacity(isFilterUsed ? 1 : 0.3)
            }
            .sheet(isPresented: $showFilterSheet) {
                FilterSheetView(
                    tempSelectedCategories: filterVM.selectedCategories,
                    selectedSortOptionRaw: filterVM.sortBy.rawValue,
                    tempSelectedPriceRange: filterVM.selectedPriceRanges,
                    filterMode: filterMode
                )
                .environmentObject(filterVM)
            }
            ScrollViewReader { scrollProxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        FilterButton(name: "Cuisines", isSelected: !foodCategories.isEmpty, action: {
                            showFoodFilter = true
                        })
                        .sheet(isPresented: $showFoodFilter) {
                            FoodFilterView(selectedCategories: selectedCategories, present: $showFoodFilter)
                                .presentationDetents([.fraction(0.35)])
                                .presentationDragIndicator(.visible)
                        }
                        if filterMode != .tenantView {
                            FilterButton(name: "Price Range", isSelected: Set(selectedPriceRange.wrappedValue) != Set(priceRangeOptions), action: {
                                showPriceRangeFilter = true
                            })
                            .sheet(isPresented: $showPriceRangeFilter) {
                                PriceRangeFilterView(options: priceRangeOptions, selectedOptions: selectedPriceRange, showPriceRangeFilter: $showPriceRangeFilter)
                                    .presentationDetents([.fraction(0.6)])
                                    .presentationDragIndicator(.visible)
                            }
                            
                            FilterButton(name: "Tenant", isSelected:!tenantCategories.isEmpty, action: {
                                showTenantFilter = true
                            })
                            .sheet(isPresented: $showTenantFilter) {
                                TenantFilterView(selectedCategories: selectedCategories, present: $showTenantFilter)
                                    .presentationDetents([.fraction(0.25)])
                                    .presentationDragIndicator(.visible)
                            }
                        }
                        
                        FilterButton(name: "Sort By", isSelected: filterVM.sortBy != .none, action: {
                            showSortByFilter = true
                        })
                        .sheet(isPresented: $showSortByFilter) {
                            SortByView(options: sortByOptions
                                       ,sortBy: $filterVM.sortBy, present: $showSortByFilter)
                            .presentationDetents([(filterMode == .tenantView ? .fraction(0.3):.fraction(0.42))])
                                .presentationDragIndicator(.visible)
                        }
                        
                    }
                    .padding(5)
                }
            }
            .frame(maxHeight: 50)
        }
    }
}

#Preview {
    @Previewable @StateObject var filterVM = FilterViewModel()
    Filter(categories: AppStorageManager.shared.foodCategories, filterMode: FilterMode.none)
        .environmentObject(filterVM)

}
