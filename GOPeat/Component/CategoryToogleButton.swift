//
//  CategoryToogleButton.swift
//  GOPeat
//
//  Created by jonathan calvin sutrisna on 12/05/25.
//

import SwiftUI

struct CategoryToogleButton: View {
    let name: String
    let isSelected: Bool
    let action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            Text(name)
                .font(.caption)
                .fontWeight(isSelected ? .medium : .regular)
                .foregroundStyle(isSelected ? Color("NonDefault") : Color.black)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(isSelected ? Color("Primary") : Color(.systemGray6))
                        .stroke(
                            Color("Secondary").opacity(isSelected ? 1 : 0.5),
                            lineWidth: 1
                        )
                )
        }

    }
}

#Preview {
    CategoryToogleButton(name: "test", isSelected: false, action: { print("x") })
}
