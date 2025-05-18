//
//  CheckBox.swift
//  GOPeat
//
//  Created by jonathan calvin sutrisna on 17/05/25.
//

import SwiftUI
struct CheckBox<T: Identifiable & Equatable>: View {
    let option: T
    @Binding var selectedOptions: [T]
    var isSelected: (T) -> Bool
    private func toggle(option: T) {
        if let index = selectedOptions.firstIndex(of: option) {
            selectedOptions.remove(at: index)
        } else {
            selectedOptions.append(option)
        }
    }
    var label: (T) -> AnyView
    var body: some View {
        Button {
            toggle(option: option)
        } label: {
            VStack(alignment: .leading) {
                HStack {
                    label(option)
                    Spacer()
                    Image(systemName: isSelected(option)
                          ? "checkmark.square.fill"
                          : "square")
                        .foregroundStyle(
                            isSelected(option)
                            ? Color("Primary")
                            : Color(.black)
                        )
                }
                Divider()
                    .frame(height: 0.5)
                    .background(.black)
            }
        }
        .buttonStyle(.plain)
    }
}
struct CheckBoxGroup<T: Identifiable & Equatable>: View {
    let options: [T]
    @Binding var selectedOptions: [T]
    private func isSelected(_ option: T) -> Bool {
        return selectedOptions.contains(option)
    }
    var label: (T) -> AnyView
    var body: some View {
        ForEach(options) { option in
            CheckBox(option: option, selectedOptions: $selectedOptions, isSelected: isSelected, label: label)
        }
    }
}

#Preview {
    struct PreviewContainer: View {
        @StateObject var filterVM: FilterViewModel
        @State var selectedOptions: [PriceRangeOption]

        init() {
            let viewModel = FilterViewModel()
            _filterVM = StateObject(wrappedValue: viewModel)
            _selectedOptions = State(initialValue: viewModel.selectedPriceRanges)
        }
        var body: some View {
            CheckBoxGroup(options: AppStorageManager.shared.allPriceRangeOptions, selectedOptions: $selectedOptions,
                label: { option in
                    AnyView(
                        HStack{
                            PriceRangeIndicator(level: option.id)
                            Text(option.label)
                        }
                    )
                }
            )
        }
    }
    return PreviewContainer()
}
