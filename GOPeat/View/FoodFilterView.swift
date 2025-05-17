//
//  FoodFilterView.swift
//  GOPeat
//
//  Created by jonathan calvin sutrisna on 13/05/25.
//

import SwiftUI

struct FoodFilterView: View {
    @Binding var selectedCategories: [String]
    @State var tempSelectedCategories:[String]
    @Binding var present: Bool
    
    init(selectedCategories: Binding<[String]>, present: Binding<Bool>) {
        self._selectedCategories = selectedCategories
        let foodCategory = selectedCategories.wrappedValue.filtered(by: AppStorageManager.shared.foodCategories)
        tenantCategories = selectedCategories.wrappedValue.filtered(by: AppStorageManager.shared.tenantCategories)
        self._tempSelectedCategories = State(initialValue:foodCategory)
        self._present = present
    }
    
    private var tenantCategories: [String]
    private func onClear() {
        selectedCategories = tenantCategories
        present = false
    }
    private func onApply() {
        selectedCategories = tenantCategories + tempSelectedCategories
        present = false
    }
    var body: some View {
        VStack(alignment: .leading,spacing: 10) {
            Spacer()
            CategoryFilter(categories: AppStorageManager.shared.foodCategories, filterMode: FilterMode.dynamicCategories, selectedCategories: $tempSelectedCategories,
               title: "Cuisine Type",
                           column: 4
            )
            .padding()
            FilterActionBar(onClear: {
                onClear()
            }, onApply: {
                onApply()
            }, isDisabled:
                tempSelectedCategories.isEmpty
            )
        }
    }
}

#Preview {
    @Previewable @State var selectedCategories:[String] = ["Spicy", "Greasy"]
    @Previewable @State var present:Bool = false
    FoodFilterView(selectedCategories: $selectedCategories, present: $present)
}
