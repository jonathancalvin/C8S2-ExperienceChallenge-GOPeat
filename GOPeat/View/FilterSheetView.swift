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
        ZStack {
            Color.white
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Filter Restaurant")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.vertical, 20)
                    
                    CategoryFilter(categories: AppStorageManager.shared.foodCategories, selectedCategories: $tempSelectedCategories,
                       title: "Cuisine Type",
                                   column: 5
                    )
                    CategoryFilter(categories: AppStorageManager.shared.tenantCategories, selectedCategories: $tempSelectedCategories,
                        title: "Tenant",
                                   column: 3
                    )
                    
                    RadioButtonGroup(
                        options: AppStorageManager.shared.allSortByOptions,
                        title: "Sort By",
                        selectedOption: $selectedOptionRaw
                    )
                }
            }
            .padding()
            VStack {
                Spacer()
                
                FilterActionBar(onClear: {
                    onClear()
                }, onApply: {
                    onApply()
                }, isDisabled:
                    isDisabled
                )
            }
        }
        .presentationDragIndicator(.visible)
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
