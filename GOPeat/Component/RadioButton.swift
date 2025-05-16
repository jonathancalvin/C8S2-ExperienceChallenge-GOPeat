//
//  RadioButton.swift
//  GOPeat
//
//  Created by jonathan calvin sutrisna on 14/05/25.
//

import SwiftUI

struct RadioButton: View {
    @Binding var selectedCategory: String
    let option: String
    var body: some View {
        Button {
            selectedCategory = option
        } label: {
            VStack {
                HStack{
                    Text(option)
                        .font(.headline)
                        .fontWeight(.regular)
                    Spacer()
                    Image(systemName: selectedCategory == option ? "circle.inset.filled" : "circle")
                        .foregroundColor(selectedCategory == option ? Color("Primary") : Color("Default"))
                }
                Divider()
                    .frame(height: 0.5)
                    .background(.black)
            }
        }
        .buttonStyle(.plain)
    }
}

struct RadioButtonGroup: View {
    let options:[String]
    let title: String
    @Binding var selectedOption: String
    var body: some View {
        VStack(alignment: .leading,spacing: 10) {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
            ForEach(options, id: \.self) { category in
                RadioButton(selectedCategory: $selectedOption, option: category)
            }

        }
        
    }
}
#Preview {
    @Previewable @State var selectedCategory: String = "None"
    var categories: [String] = AppStorageManager.shared.allSortByOptions.map {$0.rawValue}
    RadioButtonGroup(options: categories,title: "Sort By", selectedOption: $selectedCategory)
}
