//
//  PriceRangeFilterView.swift
//  GOPeat
//
//  Created by jonathan calvin sutrisna on 18/05/25.
//

import SwiftUI

struct PriceRangeFilterView: View {
    let options: [PriceRangeOption]
    @Binding var selectedOptions: [PriceRangeOption]
    @State var tempSelectedOptions: [PriceRangeOption]
    @Binding var showPriceRangeFilter: Bool
    
    init(options: [PriceRangeOption], selectedOptions: Binding<[PriceRangeOption]>, showPriceRangeFilter: Binding<Bool>) {
        self.options = options
        self._selectedOptions = selectedOptions
        self._tempSelectedOptions = State(wrappedValue: selectedOptions.wrappedValue)
        self._showPriceRangeFilter = showPriceRangeFilter
    }
    
    static var label: (PriceRangeOption) -> AnyView = { option in
        AnyView(
            HStack {
                PriceRangeIndicator(level: option.id)
                Text(option.label)
            }
        )
    }
    private func onClear() {
        selectedOptions = AppStorageManager.shared.allPriceRangeOptions
        showPriceRangeFilter = false
    }
    private func onApply() {
        selectedOptions = tempSelectedOptions
        showPriceRangeFilter = false
    }
    private var isDisabled: Bool {
        return  Set(options) == Set(tempSelectedOptions)
    }
    var body: some View {
        VStack(alignment: .leading,spacing: 10) {
            Spacer()
            Text("Price Range")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            CheckBoxGroup(
                options: options,
                selectedOptions: $tempSelectedOptions,
                label: PriceRangeFilterView.label
            ).padding()
            FilterActionBar(onClear: {
                onClear()
            }, onApply: {
                onApply()
            }, isDisabled:
                isDisabled
            )
        }
    }
}

//#Preview {
//    struct PreviewContainer: View {
//        var options: [PriceRangeOption]
//        @StateObject var filterVM: FilterViewModel
//        @State var selectedOptions: [PriceRangeOption]
//        @State var showPriceRangeFilter: Bool
//        
//        init() {
//            options = AppStorageManager.shared.allPriceRangeOptions
//            let filterVm = FilterViewModel()
//            _filterVM = StateObject(wrappedValue: filterVm)
//            _selectedOptions = State(initialValue: filterVm.selectedPriceRanges)
//            _showPriceRangeFilter = State(initialValue: false)
//        }
//        
//        var body: some View {
//            PriceRangeFilterView(options: options, selectedOptions: $selectedOptions, showPriceRangeFilter: $showPriceRangeFilter)
//        }
//    }
//    PreviewContainer()
//}

