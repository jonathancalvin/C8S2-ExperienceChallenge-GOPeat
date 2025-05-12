//
//  FilterSheetView.swift
//  GOPeat
//
//  Created by jonathan calvin sutrisna on 12/05/25.
//

import SwiftUI

struct FilterSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var maxPrice: Double
    @Binding var isOpenNow: Bool
    
    @State var tempMaxPrice: Double = 100000
    @State var tempIsOpenNow: Bool = false
    
    private func onApply(){
        maxPrice = tempMaxPrice
        isOpenNow = tempIsOpenNow
        dismiss()
    }
    private func onClear(){
        maxPrice = 100000
        isOpenNow = false
        dismiss()
    }
    var body: some View {
        ZStack {
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    Text("Filter Restaurant")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.vertical, 20)

                    Text("Price Range")
                        .font(.subheadline)
                        .fontWeight(.bold)

                    Text("Max Price: Rp.\(tempMaxPrice, specifier: "%.0f")")
                        .font(.caption)
                    Slider(value: $tempMaxPrice, in: 0...100000, step: 1000)
                    
                    Text("Availability Status")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                    Button {
                        tempIsOpenNow.toggle()
                    } label: {
                        Text("Open Now")
                            .font(.caption)
                    }
                    .foregroundStyle(tempIsOpenNow ? Color("NonDefault") : Color("Default"))
                    .padding(10)
                    .background(tempIsOpenNow ? Color.blue : Color(.systemGray5))
                    .clipShape(Capsule())
                }
            }
            VStack {
                Spacer()
                
                HStack {
                    Button {
                        onClear()
                    } label: {
                        Text("Clear Filter")
                            .foregroundStyle((tempMaxPrice != 100000 || tempIsOpenNow) ? Color.primary : Color.gray)
                            .padding(10)
                            .frame(maxWidth: .infinity)
                            .background(
                                (tempMaxPrice != 100000 || tempIsOpenNow) ? Color(.systemGray5) : Color.clear
                            )
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(Color(.systemGray5), lineWidth: 1)
                            )
                    }
                    .disabled(tempMaxPrice == 100000 && !tempIsOpenNow)
                    
                    Button {
                        onApply()
                    } label: {
                        Text("Apply")
                            .foregroundStyle(Color("NonDefault"))
                            .padding(10)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .clipShape(Capsule())
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
        }
        .onAppear {
            tempMaxPrice = maxPrice
            tempIsOpenNow = isOpenNow
        }
        .padding()
        .presentationDragIndicator(.visible)
    }
}


//#Preview {
//    FilterSheetView()
//}
