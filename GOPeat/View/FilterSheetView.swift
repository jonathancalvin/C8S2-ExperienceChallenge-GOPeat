//
//  FilterSheetView.swift
//  GOPeat
//
//  Created by jonathan calvin sutrisna on 12/05/25.
//

import SwiftUI

struct FilterSheetView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var tempSelectedCategories: [String]
    @State var selectedSortOptionRaw: String
    @State var tempSelectedPriceRange: [PriceRangeOption]

    @EnvironmentObject var filterVM: FilterViewModel
    
    let filterMode: FilterMode
    private var sortByOptions: [SortOption] {
        get {
            if filterMode == .tenantView {
                return [SortOption.premiumPrice, SortOption.affordablePrice]
            }
            return AppStorageManager.shared.allSortByOptions
        }
    }
    private var selectedSortOption: SortOption {
        return SortOption(rawValue: selectedSortOptionRaw) ?? .none
    }
    private var isDisabled: Bool {
        return (tempSelectedCategories.isEmpty && (selectedSortOption == .none) && (Set(filterVM.selectedPriceRanges) == Set(AppStorageManager.shared.allPriceRangeOptions)))
    }
    
    private func onApply(){
        filterVM.selectedCategories = tempSelectedCategories
        filterVM.sortBy = selectedSortOption
        filterVM.selectedPriceRanges = tempSelectedPriceRange
        dismiss()
    }
    private func onClear(){
        filterVM.selectedCategories = []
        filterVM.sortBy = .none
        filterVM.selectedPriceRanges = AppStorageManager.shared.allPriceRangeOptions
        dismiss()
    }
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 20) {
                    CategoryFilter(
                        categories: AppStorageManager.shared.foodCategories,
                        filterMode: .dynamicCategories,
                        selectedCategories: $tempSelectedCategories,
                        title: "Cuisine Type",
                        column: 4
                    )

                    RadioButtonGroup(
                        options: sortByOptions.map{$0.rawValue},
                        title: "Sort By",
                        selectedOption: $selectedSortOptionRaw
                    )
                    if filterMode != .tenantView {
                        VStack(alignment: .leading) {
                            Text("Price Range")
                                .font(.title)
                                .fontWeight(.bold)
                            CheckBoxGroup(
                                options: AppStorageManager.shared.allPriceRangeOptions,
                                selectedOptions: $tempSelectedPriceRange,
                                label: PriceRangeFilterView.label
                            )
                        }
                        
                        CategoryFilter(
                            categories: AppStorageManager.shared.tenantCategories,
                            filterMode: .dynamicCategories,
                            selectedCategories: $tempSelectedCategories,
                            title: "Tenant",
                            column: 3
                        )
                        Divider()
                            .frame(height: 2)
                            .background(.black)
                    }


                    CategoryFilter(
                        categories: AppStorageManager.shared.fixCategories ?? [],
                        filterMode: .fixCategories,
                        selectedCategories: $tempSelectedCategories,
                        title: "Fix Categories",
                        column: 4
                    )
                    .padding(.top, 20)
                }
                .padding()
            }
            .navigationTitle("Filter Restaurant")
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaInset(edge: .bottom) {
                FilterActionBar(
                    onClear: { onClear() },
                    onApply: { onApply() },
                    isDisabled: isDisabled
                )
                .background(.white)
            }
        }
    }
}


#Preview {
    @Previewable var filterVM: FilterViewModel = FilterViewModel()
    FilterSheetView(
        tempSelectedCategories: filterVM.selectedCategories,
        selectedSortOptionRaw: filterVM.sortBy.rawValue, tempSelectedPriceRange: filterVM.selectedPriceRanges,
        filterMode: .dynamicCategories
    )
    .environmentObject(filterVM)
}
