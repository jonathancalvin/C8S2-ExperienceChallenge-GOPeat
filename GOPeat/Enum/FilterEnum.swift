//
//  FilterEnum.swift
//  GOPeat
//
//  Created by jonathan calvin sutrisna on 15/05/25.
//

import Foundation

enum SortOption: String, CaseIterable, Identifiable {
    case none = "None"
    case nearMe = "Near Me"
    case premiumPrice = "Premium Price"
    case affordablePrice = "Affordable Price"
    var id: String { self.rawValue }
}

enum FilterMode {
    case none
    case fixCategories
    case dynamicCategories
    case tenantView
}

enum PriceRangeOption: Int, CaseIterable, Identifiable {
    case below16k = 1
    case from16kTo25k = 2
    case from25kTo40k = 3
    case over40k = 4

    var id: Int { rawValue }

    var label: String {
        switch self {
        case .below16k: return "Below Rp16.000"
        case .from16kTo25k: return "Rp 16.000 to Rp25.000"
        case .from25kTo40k: return "Rp 25.000 to Rp40.000"
        case .over40k: return "Over Rp40.000"
        }
    }
}

extension SortOption {
    var foodSortClosure: ((Food,Food)->Bool)? {
        switch self {
        case .none, .nearMe:
            return nil
        case .premiumPrice:
            return { $0.price > $1.price}
        case .affordablePrice:
            return { $0.price < $1.price }
        }
    }
    var tenantSortClosure: ((Tenant, Tenant)->Bool)? {
        switch self {
        case .none:
            return nil
        case .nearMe:
            return nil
            //TO DO: logic to determine nearme
        case .premiumPrice:
            return { PriceUtil.getMinPrice(from: $0.priceRange) > PriceUtil.getMinPrice(from: $1.priceRange)}
        case .affordablePrice:
            return { PriceUtil.getMinPrice(from: $0.priceRange) < PriceUtil.getMinPrice(from: $1.priceRange)}
        }
    }
}
