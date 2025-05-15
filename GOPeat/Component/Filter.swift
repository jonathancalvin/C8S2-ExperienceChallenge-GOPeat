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
    @Binding var maxPrice: Double?
    @Binding var isOpenNow: Bool?
    
    @State var showPriceFilter: Bool = false
    @State var showFoodFilter: Bool = false
    @State var showTenantFilter: Bool = false
    @State var isAdditionalFilterUsed: Bool = false
    
    private var foodCategories: [String] {
        get {
            return selectedCategories.filtered(by: AppStorageManager.shared.foodCategories)
        }
    }
    private var tenantCategories: [String] {
        get {
            return selectedCategories.filtered(by: AppStorageManager.shared.tenantCategories)
        }
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
    
    private func updateIsAdditionalFilterUsed(maxPrice: Double?, isOpenNow: Bool?) {
        var isMapPriceChanged = false
        var isOpenNowChanged = false
        if let _ = maxPrice {
            isMapPriceChanged = maxPrice != 100000
        }
        if let _ = isOpenNow {
            isOpenNowChanged = isOpenNow == true
        }
        isAdditionalFilterUsed = isMapPriceChanged || isOpenNowChanged
    }

    var body: some View {
        HStack {
            // Reset All Category Button
            if isAdditionalFilterUsed || !selectedCategories.isEmpty {
                Button {
                    if let _ = maxPrice {
                        maxPrice = 100000
                    }
                    if let _ = isOpenNow {
                        isOpenNow = false
                    }
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
            if let _ = maxPrice,
               let _ = isOpenNow {
                Button {
                    showPriceFilter = true
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24)
                        .foregroundStyle(Color("Default"))
                        .opacity(isAdditionalFilterUsed ? 1 : 0.3)
                }
                .onChange(of: maxPrice) { _, _ in
                    updateIsAdditionalFilterUsed(maxPrice: maxPrice, isOpenNow: nil)
                }
                .onChange(of: isOpenNow) { _, _ in
                    updateIsAdditionalFilterUsed(maxPrice: nil, isOpenNow: isOpenNow)
                }
                .sheet(isPresented: $showPriceFilter) {
                    FilterSheetView(
                        maxPrice: Binding(get: { maxPrice ?? 100000 }, set: { maxPrice = $0 }),
                        isOpenNow: Binding(get: { isOpenNow ?? false }, set: { isOpenNow = $0 })
                    )
                }
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
