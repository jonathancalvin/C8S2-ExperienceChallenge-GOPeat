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
    @State var selectedOptionRaw: String

    @EnvironmentObject var filterVM: FilterViewModel
    private var selectedOption: SortOption {
        return SortOption(rawValue: selectedOptionRaw) ?? .none
    }
    private var isDisabled: Bool {
        return (tempSelectedCategories.isEmpty && (selectedOption == .none))
    }
    private func onApply(){
        filterVM.selectedCategories = tempSelectedCategories
        filterVM.sortBy = selectedOption
        dismiss()
    }
    private func onClear(){
        filterVM.selectedCategories = []
        filterVM.sortBy = .none
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
                        options: AppStorageManager.shared.allSortByOptions.map { $0.rawValue },
                        title: "Sort By",
                        selectedOption: $selectedOptionRaw
                    )
                    
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

                    CategoryFilter(
                        categories: AppStorageManager.shared.fixCategories ?? [],
                        filterMode: .fixCategories,
                        selectedCategories: $filterVM.selectedCategories,
                        title: "Fix Categories",
                        column: 4
                    )
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
        selectedOptionRaw: filterVM.sortBy.rawValue
    )
    .environmentObject(filterVM)
}
