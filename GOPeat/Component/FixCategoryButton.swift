//
//  FixCategoryButton.swift
//  GOPeat
//
//  Created by jonathan calvin sutrisna on 16/05/25.
//

import SwiftUI

struct FixCategoryButton: View {
    let name: String
    let action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 3){
                Text(name)
                    .padding(.leading, 3)
                Image(systemName: "xmark")
            }
            .font(.caption)
            .fontWeight(.medium)
            .foregroundStyle(Color("NonDefault"))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(Color("Primary"))
                    .stroke(
                        Color("Secondary").opacity(1),
                        lineWidth: 1
                    )
            )
        }

    }
}

#Preview {
    FixCategoryButton(name: "test", action: { print("x") })

}
