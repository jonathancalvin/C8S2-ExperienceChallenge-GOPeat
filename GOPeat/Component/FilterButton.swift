//
//  FilterButton.swift
//  GOPeat
//
//  Created by jonathan calvin sutrisna on 13/05/25.
//

import SwiftUI

struct FilterButton: View {
    let name: String
    let isSelected: Bool
    let action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 5){
                Text(name)
                    .font(.subheadline)
                    .padding(.leading, 5)
                Image(systemName: "chevron.down")
            }
            .foregroundStyle(.black)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                Capsule()
                    .fill(isSelected ? Color("Primary").opacity(0.5) : Color("Gray"))
                    .stroke(.black, lineWidth: 1)
            )
        }

    }
}

#Preview {
    FilterButton(name: "Food", isSelected: false) {
        print("yes")
    }
}
