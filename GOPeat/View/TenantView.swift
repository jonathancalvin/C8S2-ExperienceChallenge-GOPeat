//
//  CanteenCard.swift
//  GOPeat
//
//  Created by Oxa Marvel on 24/03/25.
//


import SwiftUI

let sampleImages = ["image1", "image2", "image3", "image4", "image5"]


// Tenant Page
struct TenantView: View {
    @Environment(\.dismiss) var dismiss
    let foods: [Food]
    let tenant: Tenant
    let symbol: String
    let color: Color
    @State var selectedCategories: [String]
    @StateObject private var viewModel: TenantViewModel
    
    @State private var maxPrice: Double? = nil
    @State private var isOpenNow: Bool? = nil

    
    init(tenant: Tenant, foods: [Food], selectedCategories: [String]) {
        self.foods = foods
        self.tenant = tenant
        let isHalal = tenant.isHalal ?? false
        self.symbol = isHalal ? "checkmark.circle.fill" : "xmark.circle.fill"
        self.color = isHalal ? .green : .red
        self.selectedCategories = selectedCategories
        _viewModel = StateObject(wrappedValue: TenantViewModel(foods: foods))
        
        let appear = UINavigationBarAppearance()
        
        appear.shadowColor = .clear
        appear.shadowImage = UIImage()
        
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().standardAppearance = appear
        UINavigationBar.appearance().compactAppearance = appear
        UINavigationBar.appearance().scrollEdgeAppearance = appear
        
        UITabBar.appearance().isHidden = true
    }
    private func tenantHeader() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack (alignment: .leading) {
                Text(tenant.name)
                    .font(.largeTitle.bold())
                Text(tenant.canteen?.name ?? "")
                    .font(.body)
                //.foregroundColor(.gray)
                Spacer()
            }

            
            HStack() {
                VStack(alignment: .leading, spacing: 10) {
                    Label(tenant.operationalHours, systemImage: "clock")
                    
                    HStack() {
                        Label(tenant.contactPerson, systemImage: "phone")
                        Text("(Pre-order")
                        (Text(Image(systemName: symbol)).foregroundColor(color) + Text(")"))
                            .font(.body)
                    }
                }
                
                Spacer()
                
                if true {
                    Image("halal")
                        .resizable()
                        .frame(width: 40, height: 40)
                } else {
                    /*@START_MENU_TOKEN@*/EmptyView()/*@END_MENU_TOKEN@*/
                }
            }
        }
        .padding(.horizontal)
    }
    
    private func imageSlider(image: [String]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(image, id: \.self) { imageName in
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 150, height: 200)
                        .overlay(
                            Image(systemName: "photo")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                        )
                }
            }
            .padding(.horizontal)
        }
    }
    var body: some View {
        NavigationView {
            ZStack (alignment: .top){
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // Tenant Header
                        tenantHeader()
                        
                        // Tenant's Side-scrolling images
                        imageSlider(image: sampleImages)
                        
                        // Filter Component
                        Filter(categories: viewModel.categories, selectedCategories: $selectedCategories, maxPrice: $maxPrice, isOpenNow: $isOpenNow)
                            .onChange(of: selectedCategories) { _, _ in
                                viewModel.updateFilteredFood(selectedCategories: selectedCategories)
                            }
                            .padding(.horizontal, 20)
                        
                        // List of Food
                        VStack(spacing: 10) {
                            if viewModel.filteredFoods.count == 1 && viewModel.filteredFoods.first?.name == "Dumy" {
                                Text("Not Found")
                                    .font(.subheadline)
                                    .bold()
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.top, 10)
                                
                            } else {
                                ForEach(viewModel.filteredFoods.filter { $0.name != "Dumy" }) { food in
                                    FoodCard(food: food)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
                .scrollIndicators(.hidden)
            }
            .onAppear(){
                selectedCategories = selectedCategories.filtered(by: AppStorageManager.shared.foodCategories)
                viewModel.updateFilteredFood(selectedCategories: selectedCategories)
            }
            .ignoresSafeArea(edges: .bottom)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        (Text(Image(systemName: "chevron.left"))
                         + Text(" Back"))
                    }
                }
            }
        }
    }
}

// Food Card
struct FoodCard: View {
    let food: Food
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(food.name)
                    .font(.headline)
                    
                Text(food.desc)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 5) {
                        ForEach(food.categories, id: \.self) { category in
                            Text(category.rawValue)
                                .padding(5)
                                .font(.caption)
                                .foregroundColor(.primary)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(3)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 3)
                                        .stroke(Color.gray.opacity(0.0), lineWidth: 1)
                                    )
                        }
                    }
                }
                .padding(.top, 10)
            }
                
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.07))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.0), lineWidth: 1)
        )
    }
}
