//
//  PriceRangeIndicator.swift
//  GOPeat
//
//  Created by jonathan calvin sutrisna on 18/05/25.
//

import SwiftUI

struct PriceRangeIndicator: View {
    let level: Int

    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<4) { index in
                Image(systemName: "dollarsign")
                    .resizable()
                    .frame(maxWidth: 8, maxHeight: 13)
                    .opacity(index < level ? 1 : 0.5)
            }
        }
    }
}

#Preview {
    PriceRangeIndicator(level: 1)
}
