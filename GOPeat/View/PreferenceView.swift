//
//  PreferenceView.swift
//  GOPeat
//
//  Created by jonathan calvin sutrisna on 09/05/25.
//

import SwiftUI

struct PreferenceView: View {
    @State var selectedCategories: [String] = []
    @State var shouldNavigate: Bool = false
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
                    Spacer()
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
                        CategoryFilter(categories: Food.availableFixedCategory, selectedCategories: $selectedCategories,
                                       title: "",
                                       column: 4
                        )
                    }
                        .frame(width: geometry.size.width * 0.7)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 30)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("NonDefault"))
                                .stroke(Color("Default"), lineWidth: 1)
                        )
                    Spacer()
                    Button("Continue") {
                        AppStorageManager.shared.fixCategories = selectedCategories
                        AppStorageManager.shared.hasCompletedPreference = true
                        shouldNavigate = true
                    }
                    .frame(width: geometry.size.width * 0.7)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .foregroundStyle(Color("NonDefault"))
                    .background(
                        Capsule()
                            .fill(Color("Primary"))
                    )
                    NavigationLink(
                        destination: ContentView(),
                        isActive: $shouldNavigate,
                        label: { EmptyView() }
                    )
                }
            }
        }
    }
}

#Preview {
    PreferenceView()
}
