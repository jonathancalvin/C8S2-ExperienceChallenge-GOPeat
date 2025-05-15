//
//  SortByView.swift
//  GOPeat
//
//  Created by jonathan calvin sutrisna on 15/05/25.
//

import SwiftUI

struct SortByView: View {
    let options:[String] = AppStorageManager.shared.allSortByOptions
    @Binding var sortBy: String
    @Binding var present: Bool
    @State var selectedOption: String
    init(sortBy: Binding<String>, present: Binding<Bool>) {
        self._sortBy = sortBy
        self.selectedOption = sortBy.wrappedValue
        self._present = present
    }
    private func onClear(){
        sortBy = SortOption.none.rawValue
        present = false
    }
    private func onApply() {
        sortBy = selectedOption
        present = false
    }
    var body: some View {
        VStack {
            Spacer()
            RadioButtonGroup(options: options, title: "Sort By", selectedOption: $selectedOption)
            FilterActionBar(onClear: {onClear()}, onApply: {onApply()}, isDisabled: selectedOption == SortOption.none.rawValue)
        }
    }
}

#Preview {
    @Previewable @State var sortBy: String = SortOption.none.rawValue
    @Previewable @State var present: Bool = false
    SortByView(sortBy: $sortBy, present: $present)
}
