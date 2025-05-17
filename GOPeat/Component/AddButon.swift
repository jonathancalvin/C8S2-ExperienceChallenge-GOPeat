//
//  AddButon.swift
//  GOPeat
//
//  Created by jonathan calvin sutrisna on 17/05/25.
//

import SwiftUI

struct AddButon: View {
    var action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 18, height: 18)
            }
            .padding()
            .background(
                Capsule()
                    .fill(Color("Primary").opacity(0.25))
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    AddButon(action: {print("x")})
}
