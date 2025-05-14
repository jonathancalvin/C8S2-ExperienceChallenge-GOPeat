//
//  CategoryEnum.swift
//  GOPeat
//
//  Created by jonathan calvin sutrisna on 14/05/25.
//

import Foundation

enum CategoryType {
    case food
    case tenant
    
    var categories: [String] {
        switch self {
        case .food:
            return FoodCategory.allCases.map { $0.rawValue }
        case .tenant:
            return ["Halal", "Non-Halal", "Open Now"]
        }
    }
}
