//
//  FilterActionBar.swift
//  GOPeat
//
//  Created by jonathan calvin sutrisna on 13/05/25.
//

import SwiftUI

struct FilterActionBar: View {
    let onClear: () -> Void
    let onApply: () -> Void
    let isDisabled: Bool
    var body: some View {
        HStack {
            Button {
                onClear()
            } label: {
                Text("Clear Filter")
                    .foregroundStyle(isDisabled ? .black : Color("Red"))
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(
                        Capsule()
                            .fill(.white)
                            .stroke(isDisabled ? .black : Color("Red"))
                    )
            }
            .disabled(isDisabled)
            
            Button {
                onApply()
            } label: {
                Text("Apply")
                    .foregroundStyle(Color.white)
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(Color("Primary"))
                    .clipShape(Capsule())
            }
        }
        .fontWeight(.medium)
        .padding(15)
        .background(
            Color.white
                .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: -3)
                .mask(Rectangle().padding(.top, -20))
        )
    }
}

#Preview {
    FilterActionBar(
        onClear: {
            print("Clear pressed")
        },
        onApply: {
            print("Apply pressed")
        },
        isDisabled: true
    )
}

