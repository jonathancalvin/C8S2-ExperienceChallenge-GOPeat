//
//  PriceUtil.swift
//  GOPeat
//
//  Created by jonathan calvin sutrisna on 12/05/25.
//

import Foundation

struct PriceUtil {
    static func getMinPrice(from range: String) -> Int {
        let parts = range.components(separatedBy: "-")
        let min = parts.first?.replacingOccurrences(of: ".", with: "") ?? "0"
        return Int(min) ?? 0
    }
    static func getActiveDollarSign(for price: Int) -> Int {
        switch price{
            case ..<16000:
                return 1
            case 16000..<25000:
                return 2
            case 25000..<40000:
                return 3
            default:
                return 4
        }
    }
}
