//
//  Array+Extension.swift
//  GOPeat
//
//  Created by jonathan calvin sutrisna on 14/05/25.
//

extension Array where Element == String {
    func filtered(by categories: [String]) -> [String] {
        return self.filter {categories.contains($0)}
    }
}
