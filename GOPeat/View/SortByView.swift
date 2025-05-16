//
//  SortByView.swift
//  GOPeat
//
//  Created by jonathan calvin sutrisna on 15/05/25.
//

import SwiftUI

struct SortByView: View {
    let options:[String] = AppStorageManager.shared.allSortByOptions
    @Binding var present: Bool
    @Binding var sortBy: SortOption
    @State private var selectedOptionRaw: String
    init(sortBy: Binding<SortOption>, present: Binding<Bool>) {
        self._sortBy = sortBy
        self._present = present
        self._selectedOptionRaw = State(initialValue: sortBy.wrappedValue.rawValue)
    }
    private var selectedOptionBinding: Binding<String> {
        Binding<String>(
            get: { sortBy.rawValue },
            set: { newValue in
                sortBy = SortOption(rawValue: newValue) ?? .none
            }
        )
    }
    private var selectedOption: SortOption {
        return SortOption(rawValue: selectedOptionRaw) ?? .none
    }
    private func onClear(){
        sortBy = SortOption.none
        present = false
    }
    private func onApply() {
        sortBy = selectedOption
        present = false
    }
    
    var body: some View {
        VStack(spacing: 10){
            Spacer()
            RadioButtonGroup(
                options: options,
                title: "Sort By",
                selectedOption: $selectedOptionRaw
            )
                .padding()
            FilterActionBar(
                onClear: { onClear() },
                onApply: { onApply() },
                isDisabled: selectedOption == .none
            )
        }
    }
}

#Preview {
    @Previewable @State var sortBy: SortOption = SortOption.none
    @Previewable @State var present: Bool = false
    SortByView(sortBy: $sortBy, present: $present)
}
