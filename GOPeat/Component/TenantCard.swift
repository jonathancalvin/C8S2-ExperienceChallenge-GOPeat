//
//  TenantCard.swift
//  GOPeat
//
//  Created by jonathan calvin sutrisna on 07/04/25.
//

import SwiftUI

struct TenantCard: View {
    let tenant: Tenant
    @State var showTenantDetail = false
    @EnvironmentObject var filterVM: FilterViewModel
    let displayFoods: [Food]
    private func infoRow(label: Image, value: String) -> some View {
        HStack(alignment: .top) {
            Text("\(label):")
            Text(value)
        }
        .font(.subheadline)
    }
    private func tenantDetail(activeDollarSign: Int) -> some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center,spacing: 0){
                Text(tenant.name)
                    .font(.headline)
                    .bold()
                    .padding(.bottom,5)
                Image("Halal")
                    .resizable()
                    .frame(maxWidth: 35, maxHeight: 35)
                Image("Preorder")
                    .resizable()
                    .frame(maxWidth: 25, maxHeight: 25)
            }
            HStack(spacing: 2) {
                ForEach(0..<4){ index in
                    Image(systemName: "dollarsign")
                        .resizable()
                        .frame(maxWidth: 8, maxHeight: 13)
                        .opacity(index < activeDollarSign ? 1: 0.5)
                }
            }
            infoRow(label: Image(systemName: "clock"), value: tenant.operationalHours)
            infoRow(label: Image(systemName: "phone"), value: tenant.contactPerson)
        }

    }
    @ViewBuilder
    func foodImage(for food: Food) -> some View {
        let isDefault = food.image == "defaultFood"
        let image: Image = isDefault
            ? Image(systemName: "fork.knife.circle")
            : Image(food.image)

        image
            .resizable()
            .foregroundStyle(isDefault ? Color("Gray") : Color.primary)
            .padding(isDefault ? 8 : 0)
            .frame(maxWidth: 75, maxHeight: 75)
            .scaledToFill()
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(.systemGray6), lineWidth: isDefault ? 3 : 0)
            )
    }
    var body: some View {
        let activeDollarSign = PriceUtil.getActiveDollarSign(for: PriceUtil.getMinPrice(from: tenant.priceRange))
        Button(action: {
            showTenantDetail = true
        }) {
            VStack(spacing: 20) {
                HStack {
                    Image(tenant.image)
                        .resizable()
                        .frame(maxWidth: 120, maxHeight: 110)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    tenantDetail(activeDollarSign: activeDollarSign)
                    Spacer()
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(displayFoods) {food in
                            VStack(alignment: .leading) {
                                foodImage(for: food)

                                Text("Rp \(food.price)")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Text(food.name)
                                    .font(.caption)
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.3)
                                    .fixedSize(horizontal: false, vertical: true)
                                Spacer()
                            }
                            .frame(maxWidth: 75, minHeight: 140)
                        }
                    }
                }
            }
            .padding(10)
            .background(.white.shadow(ShadowStyle.drop(radius: 3)))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .foregroundColor(Color("Default"))

        }
        .buttonStyle(.plain)
        .fullScreenCover(isPresented: $showTenantDetail) {
            showTenantDetail = false
        } content: {
            TenantView(tenant: tenant, foods: tenant.foods, tenantVM: TenantViewModel(foods: tenant.foods, filterVM: filterVM))
                .environmentObject(filterVM)
        }
    }
}

#Preview {
    @Previewable @State var selectedCategories = AppStorageManager.shared.allCategories
    @Previewable var tenant: Tenant = Tenant(name: "Mama Djempol",
                                             image: "MamaDjempolGE",
                                             contactPerson: "08123456789",
                                             preorderInformation: true,
                                             operationalHours: "09:00-14:00", isHalal: true, canteen: nil, priceRange: "16.000-25.000")
    TenantCard(tenant: tenant, displayFoods: tenant.foods)
}
