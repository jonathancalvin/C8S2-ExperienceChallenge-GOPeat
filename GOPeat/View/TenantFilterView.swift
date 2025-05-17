//
//  TenantFilterView.swift
//  GOPeat
//
//  Created by jonathan calvin sutrisna on 14/05/25.
//

import SwiftUI

struct TenantFilterView: View {
    @Binding var selectedCategories: [String]
    @State var tempSelectedCategories:[String]
    @Binding var present: Bool
    
    init(selectedCategories: Binding<[String]>, present: Binding<Bool>) {
        self._selectedCategories = selectedCategories
        let tenantCategories = selectedCategories.wrappedValue.filtered(by: AppStorageManager.shared.tenantCategories)
        foodCategories = selectedCategories.wrappedValue.filtered(by: AppStorageManager.shared.foodCategories)
        self._tempSelectedCategories = State(initialValue:tenantCategories)
        self._present = present
    }
    
    private var foodCategories: [String]
    private func onClear() {
        selectedCategories = foodCategories
        present = false
    }
    private func onApply() {
        selectedCategories = foodCategories + tempSelectedCategories
        present = false
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Spacer()
            CategoryFilter(categories: AppStorageManager.shared.tenantCategories, filterMode: FilterMode.dynamicCategories, selectedCategories: $tempSelectedCategories,
                title: "Tenant",
                           column: 3
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
    @Previewable @State var selectedCategories:[String] = ["Halal"]
    @Previewable @State var present:Bool = false
    TenantFilterView(selectedCategories: $selectedCategories, present: $present)
}
