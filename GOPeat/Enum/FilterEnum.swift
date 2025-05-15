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
