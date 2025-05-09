//
//  PreferenceView.swift
//  GOPeat
//
//  Created by jonathan calvin sutrisna on 09/05/25.
//

import SwiftUI

struct PreferenceView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color("Gray")
                    .ignoresSafeArea()
                
                VStack {
                    Image("AppImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Hello There")
                                .font(.title)
                                .fontWeight(.semibold)
                            Text("Tell us what you eat and let's make food work for you.")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        Text("Choose what suits your diet and lifestyle — from halal to non-spicy or anything in between.")
                    }
                    .frame(width: geometry.size.width * 0.7)
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                            .stroke(Color.black, lineWidth: 1)
                    )
                }
            }
        }
    }
}

#Preview {
    PreferenceView()
}
