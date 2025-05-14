//
//  ContentView.swift
//  GOPeat
//
//  Created by jonathan calvin sutrisna on 09/03/25.
//

import SwiftUI
import MapKit
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query var canteens: [Canteen]
    @Query var tenants: [Tenant]
    @State private var showSheet = true
    @State private var isDataLoaded = false
    
    private func insertInitialData() async {
        // Create Canteen
        let greenEatery = Canteen(name: "Green Eatery",
            latitude: -6.302180333605081,
            longitude:  106.65229958867403,
            image: "GreenEatery",
          desc: "Modern food court featuring diverse dishes",
          operationalTime: "Monday - Friday: 6 AM - 9 PM",
          amenities: ["Disabled Access", "Smoking Area", "Convenience Store"]
        )
        let gOP6 = Canteen(name: "GOP 6 Canteen",
            latitude: -6.303134809023461,
            longitude:  106.65281577080749,
            image: "GOP6",
           desc: "Popular food court with multiple food stalls",
           operationalTime: "Monday - Saturday: 6:30 AM - 8 PM",
           amenities: ["Prayer Room", "ATM", "Printing Services"]
        )
        let gOP1 = Canteen(name: "GOP 1 Canteen",
            latitude: -6.301780422262836,
            longitude:  106.65017405960315,
            image: "GOP1",
           desc: "Main cafeteria at GOP 1 offering various cuisines",
           operationalTime: "Monday - Friday: 7 AM - 7 PM",
           amenities: ["Free WiFi", "Air Conditioned", "Outdoor Seating"]
        )
        let theBreeze = Canteen(name: "The Breeze Food Court",
            latitude: -6.301495171206343,
            longitude:  106.65514273021897,
            image: "TheBreeze",
            desc: "Spacious food court with outdoor seating",
            operationalTime: "Daily: 8 AM - 10 PM",
            amenities: ["Live Music", "Event Space", "Premium Dining"]
        )
        context.insert(greenEatery)
        context.insert(gOP6)
        context.insert(gOP1)
        context.insert(theBreeze)
        
        // Create Tenant -- greenEatery
        let mamaDjempol = Tenant(name: "Mama Djempol",
               image: "MamaDjempolGE",
               contactPerson: "08123456789",
               preorderInformation: true,
                                 operationalHours: "09:00-14:00", isHalal: true, canteen: greenEatery, priceRange: "16.000-25.000")
        let kasturi = Tenant(name: "Kasturi",
               image: "Kasturi",
               contactPerson: "08123456789",
               preorderInformation: true,
                             operationalHours: "09:00-14:00", isHalal: true, canteen: greenEatery, priceRange: "13.000-20.000")
        let laDing = Tenant(name: "La Ding",
               image: "LaDing",
               contactPerson: "08123456789",
               preorderInformation: true,
                            operationalHours: "09:00-14:00", isHalal: true, canteen: greenEatery, priceRange: "17.000-35.000")
        let dapurMiminTenant = Tenant(name: "Dapur Mimin",
                                                image: "dapurMimin",
                                                contactPerson: "-",
                                                preorderInformation: false,
                                                operationalHours: "11:00-17:00", isHalal: true, canteen: gOP6, priceRange: "18.000-25.000")
                // Create Tenant -- GOP 6 (Nasi Padang)
                let nasiPadangTenant = Tenant(name: "Nasi Kapau Nusantara", // Example name
                                                image: "NasiPadang", // Replace with actual image name
                                                contactPerson: "08987654321",
                                                preorderInformation: true,
                                                operationalHours: "10:00-16:00", isHalal: true, canteen: gOP6, priceRange: "15.000-30.000")
        // TO DO - create tenant for each canteen (gOP6, gOP1, theBreeze)
        
        // Masukkan Tenant ke context
        context.insert(mamaDjempol)
        context.insert(kasturi)
        context.insert(laDing)
        context.insert(dapurMiminTenant)
        context.insert(nasiPadangTenant)

        
        // create food for each canteen
        let kasturiFoods = [
            Food(name: "Sapi Lada Hitam", description: "Sapi dengan saus lada hitam", categories: [.spicy, .savory, .greasy], tenant: kasturi, price: 14500, image: "defaultFood"),
            Food(name: "Sawi Putih", description: "Sawi putih rebus", categories: [.nonSpicy, .nonGreasy, .nonSweet], tenant: kasturi, price: 13500, image: "defaultFood"),
            Food(name: "Otak-Otak", description: "Otak-otak bakar khas", categories: [.nonSpicy, .nonGreasy, .nonSweet], tenant: kasturi, price: 14000, image: "defaultFood"),
            Food(name: "Telur Ponti", description: "Telur khas Pontianak", categories: [.savory, .spicy, .greasy], tenant: kasturi, price: 15000, image: "defaultFood"),
            Food(name: "Ikan Tongkol", description: "Ikan tongkol dengan bumbu", categories: [.greasy, .savory], tenant: kasturi, price: 14200, image: "defaultFood"),
            Food(name: "Kentang Mustofa", description: "Kentang goreng kering", categories: [.greasy, .sweet], tenant: kasturi, price: 13500, image: "defaultFood"),
            Food(name: "Tempe Kering", description: "Tempe goreng kering", categories: [.greasy, .savory], tenant: kasturi, price: 13000, image: "defaultFood"),
            Food(name: "Ayam Kering", description: "Ayam goreng kering", categories: [.greasy, .savory], tenant: kasturi, price: 14500, image: "ayamBakar"),
            Food(name: "Teri Kacang", description: "Teri goreng dengan kacang", categories: [.nonSpicy, .greasy, .sweet], tenant: kasturi, price: 13500, image: "defaultFood"),
            Food(name: "Ayam Bakar", description: "Ayam bakar kecap", categories: [.nonSpicy, .savory, .sweet], tenant: kasturi, price: 15000, image: "ayamGulai"),
            Food(name: "Ayam Rendang", description: "Ayam dengan bumbu rendang", categories: [.nonSpicy], tenant: kasturi, price: 14000, image: "ayamBakar"),
            Food(name: "Ayam Gulai", description: "Ayam dengan kuah gulai", categories: [.nonGreasy, .nonSpicy], tenant: kasturi, price: 13800, image: "ayamGulai")
        ]
        
        let laDingFoods = [
            Food(name: "Soto Mie", description: "Soto mie khas Bogor", categories: [.soup, .nonSpicy, .savory], tenant: laDing, price: 23000, image: "defaultFood"),
            Food(name: "Sop Iga", description: "Sup iga sapi", categories: [.soup, .nonSpicy, .savory], tenant: laDing, price: 25000, image: "defaultFood"),
            Food(name: "Sop Daging", description: "Sup daging sapi", categories: [.soup, .nonSpicy, .savory], tenant: laDing, price: 24000, image: "defaultFood"),
            Food(name: "Somay", description: "Siomay khas Bandung", categories: [.savory], tenant: laDing, price: 22000, image: "defaultFood"),
            Food(name: "Nasi Uduk", description: "Nasi gurih khas Jakarta", categories: [.savory], tenant: laDing, price: 20000, image: "defaultFood")
        ]
        
            let mamaDjempolFoods = [
                Food(name: "Ayam Lada Hitam", description: "Ayam dengan saus lada hitam", categories: [.nonGreasy, .spicy, .savory], tenant: mamaDjempol, price: 19000, image: "ayamBakar"),
                Food(name: "Ayam Jamur Kancing", description: "Ayam dengan jamur kancing", categories: [.nonGreasy, .nonSpicy, .savory], tenant: mamaDjempol, price: 18000, image: "ayamGulai"),
                Food(name: "Ayam Saus Madu", description: "Ayam dengan saus madu", categories: [.greasy, .nonSpicy, .savory], tenant: mamaDjempol, price: 20000, image: "ayamBakar"),
                Food(name: "Ayam Pedas Manis", description: "Ayam dengan bumbu pedas manis", categories: [.greasy, .spicy, .savory], tenant: mamaDjempol, price: 19000, image: "ayamGulai"),
                Food(name: "Ayam Saus Padang", description: "Ayam dengan saus Padang", categories: [.greasy, .spicy, .savory], tenant: mamaDjempol, price: 20000, image: "ayamBakar"),
                Food(name: "Ayam Sambal Hijau", description: "Ayam dengan sambal hijau", categories: [.greasy, .spicy, .savory], tenant: mamaDjempol, price: 19000, image: "ayamGulai"),
                Food(name: "Ayam Suwir", description: "Ayam suwir pedas", categories: [.greasy, .spicy, .savory], tenant: mamaDjempol, price: 18000, image: "ayamBakar"),
                Food(name: "Ikan Dori", description: "Ikan dori goreng", categories: [.greasy, .nonSpicy, .savory], tenant: mamaDjempol, price: 20000, image: "defaultFood"),
                Food(name: "Cumi Rica", description: "Cumi dengan bumbu rica", categories: [.greasy, .spicy, .savory], tenant: mamaDjempol, price: 20000, image: "defaultFood"),
                Food(name: "Ikan Tongkol Balado", description: "Ikan tongkol dengan balado", categories: [.greasy, .spicy, .savory], tenant: mamaDjempol, price: 19000, image: "defaultFood"),
                Food(name: "Tempe Orek", description: "Tempe goreng kecap", categories: [.greasy, .nonSpicy, .savory], tenant: mamaDjempol, price: 17000, image: "defaultFood"),
                Food(name: "Kangkung", description: "Tumis kangkung", categories: [.nonGreasy, .spicy, .savory], tenant: mamaDjempol, price: 16000, image: "defaultFood"),
                Food(name: "Sayur Toge", description: "Tumis toge", categories: [.nonGreasy, .nonSpicy], tenant: mamaDjempol, price: 16000, image: "defaultFood")
            ]

            let dapurMiminFoods = [
                Food(name: "Tempe", description: "Tempe.", categories: [.nonSpicy, .savory], tenant: dapurMiminTenant, price: 26000, image: "defaultFood"),
                Food(name: "Telor Kecap", description: "Telur, kecap.", categories: [.nonSpicy, .sweet, .savory], tenant: dapurMiminTenant, price: 27000, image: "defaultFood"),
                Food(name: "Jamur Cabe Garam", description: "Jamur, cabe, garam.", categories: [.spicy, .savory], tenant: dapurMiminTenant, price: 29000, image: "defaultFood"),
                Food(name: "Ikan Bandeng Presto", description: "Ikan bandeng presto.", categories: [.nonSpicy, .savory], tenant: dapurMiminTenant, price: 30000, image: "defaultFood"),
                Food(name: "Perkedel Jagung", description: "Jagung, goreng.", categories: [.nonSpicy, .sweet, .savory], tenant: dapurMiminTenant, price: 28000, image: "defaultFood"),
                Food(name: "Tahu Telur Nasi", description: "Tahu, telur, nasi, saus kacang.", categories: [.nonSpicy, .savory], tenant: dapurMiminTenant, price: 27000, image: "defaultFood"),
                Food(name: "Gado Polos", description: "Sayuran, bumbu kacang.", categories: [.nonSpicy, .savory], tenant: dapurMiminTenant, price: 26000, image: "defaultFood"),
                Food(name: "Gado Gado + Telur", description: "Sayuran, bumbu kacang, telur.", categories: [.nonSpicy, .savory], tenant: dapurMiminTenant, price: 28000, image: "defaultFood"),
                Food(name: "Mieprak", description: "Mie instan.", categories: [.savory], tenant: dapurMiminTenant, price: 29000, image: "defaultFood"),
                Food(name: "Nasi Kebuli", description: "Nasi, rempah, kaldu.", categories: [.savory], tenant: dapurMiminTenant, price: 30000, image: "defaultFood"),
                Food(name: "Nasi Briyani", description: "Nasi, rempah, daging.", categories: [.savory], tenant: dapurMiminTenant, price: 30000, image: "defaultFood"),
                Food(name: "Siomay (3 pcs)", description: "Ikan, tepung, bumbu kacang.", categories: [.savory], tenant: dapurMiminTenant, price: 27000, image: "defaultFood"),
                Food(name: "Soto Ayam", description: "Ayam, kuah soto, rempah.", categories: [.nonSpicy, .savory, .soup], tenant: dapurMiminTenant, price: 29000, image: "ayamGulai"),
                Food(name: "Tahu Sechyan", description: "Tahu, bumbu Szechuan.", categories: [.spicy, .savory], tenant: dapurMiminTenant, price: 26000, image: "defaultFood")
            ]


            let nasiPadangFoods = [
                Food(name: "Nasi Padang", description: "Nasi dengan berbagai pilihan lauk khas Padang.", categories: [.savory], tenant: nasiPadangTenant, price: 45000, image: "defaultFood"),
                Food(name: "Rendang Daging", description: "Daging sapi yang dimasak dalam bumbu rendang yang kaya rempah.", categories: [.nonSpicy, .savory], tenant: nasiPadangTenant, price: 48000, image: "defaultFood"),
                Food(name: "Ayam Gulai", description: "Ayam yang dimasak dalam kuah gulai kuning yang gurih.", categories: [.nonSpicy, .savory], tenant: nasiPadangTenant, price: 46000, image: "ayamGulai"),
                Food(name: "Ayam Bakar", description: "Ayam yang dibakar dengan bumbu khas.", categories: [.nonSpicy, .savory], tenant: nasiPadangTenant, price: 47000, image: "ayamBakar"),
                Food(name: "Ikan Bakar", description: "Ikan yang dibakar dengan bumbu khas.", categories: [.nonSpicy, .savory], tenant: nasiPadangTenant, price: 49000, image: "defaultFood"),
                Food(name: "Telur Dadar", description: "Telur dadar khas Padang yang tebal dan renyah.", categories: [.nonSpicy, .savory], tenant: nasiPadangTenant, price: 42000, image: "defaultFood"),
                Food(name: "Sayur Nangka", description: "Gulai nangka muda.", categories: [.nonSpicy, .savory], tenant: nasiPadangTenant, price: 40000, image: "defaultFood"),
                Food(name: "Daun Singkong", description: "Daun singkong rebus yang dibumbui.", categories: [.nonSpicy, .savory], tenant: nasiPadangTenant, price: 40000, image: "defaultFood"),
                Food(name: "Sambal Ijo", description: "Sambal cabai hijau khas Padang.", categories: [.spicy, .savory], tenant: nasiPadangTenant, price: 42000, image: "defaultFood"),
                Food(name: "Kerupuk Kulit", description: "Kerupuk kulit sapi goreng.", categories: [.nonSpicy, .savory, .greasy], tenant: nasiPadangTenant, price: 43000, image: "defaultFood")
            ]
            //TO DO - create food for other tenant

            // Insert semua data ke dalam modelContext
            let allFoods = kasturiFoods + laDingFoods + mamaDjempolFoods + dapurMiminFoods + nasiPadangFoods
            for food in allFoods {
                context.insert(food)
            }
            do {
                try context.save()
            } catch {
                fatalError(error.localizedDescription)
            }
            print("Insert Initial Data Success")
            print("===============================")
        }
        //TO DO - create food for other tenant
        
        // Insert semua data ke dalam modelContext
    
    private func deleteInitialData() async {
        do {
            let canteens = try context.fetch(FetchDescriptor<Canteen>())
            for canteen in canteens {
                context.delete(canteen)
            }
            
            let tenants = try context.fetch(FetchDescriptor<Tenant>())
            for tenant in tenants {
                context.delete(tenant)
            }
            
            let foods = try context.fetch(FetchDescriptor<Food>())
            for food in foods {
                context.delete(food)
            }
            
            try context.save()
        } catch {
            fatalError(error.localizedDescription)
        }
        
        print("Delete Initial Success")
        print("===============================")
    }
    private func showInsertedData() {
        for canteen in canteens {
            print("=== Canteens ===")
            print("Nama: \(canteen.name), Lokasi: (\(canteen.latitude), \(canteen.longitude))")
            for tenant in canteen.tenants {
                print("Nama: \(tenant.name) Halal: \( (tenant.isHalal ?? false) ? "Yes" : "No")")
                for food in tenant.foods {
                    print("Nama: \(food.name), Deskripsi: \(food.desc), Tenant: \(food.tenant?.name ?? "Unknown")")
                }
            }
        }
    }
    var body: some View {
        NavigationStack {
            Group {
                if AppStorageManager.shared.hasCompletedPreference {
                    MapView(tenants: tenants, canteens: canteens)
                }
                else if isDataLoaded {
                    PreferenceView()
                } else {
                    ProgressView("Loading data...")
                }
            }
            .task {
                if canteens.isEmpty {
                    await deleteInitialData()
                    await insertInitialData()
                }
                showInsertedData()
                isDataLoaded = true
            }
            .toolbar(.hidden)
        }
    }
}

#Preview {
    ContentView()
}
