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
    static func getPriceRangeOption(for price: Int) -> PriceRangeOption {
        switch price{
            case ..<16000:
            return PriceRangeOption.below16k
            case 16000..<25000:
            return PriceRangeOption.from16kTo25k
            case 25000..<40000:
            return PriceRangeOption.from25kTo40k
            default:
            return PriceRangeOption.over40k
        }
    }
}
