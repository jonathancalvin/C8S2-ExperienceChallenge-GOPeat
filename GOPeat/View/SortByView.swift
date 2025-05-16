//
//  SortByView.swift
//  GOPeat
//
//  Created by jonathan calvin sutrisna on 15/05/25.
//

import SwiftUI

struct SortByView: View {
    let options:[SortOption]
    @Binding var present: Bool
    @Binding var sortBy: SortOption
    @State private var selectedOptionRaw: String
    init(options: [SortOption] ,sortBy: Binding<SortOption>, present: Binding<Bool>) {
        self.options = options
        self._sortBy = sortBy
        self._present = present
        self._selectedOptionRaw = State(initialValue: sortBy.wrappedValue.rawValue)
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
                options: options.map { $0.rawValue },
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
    SortByView(options: AppStorageManager.shared.allSortByOptions,sortBy: $sortBy, present: $present)
}
