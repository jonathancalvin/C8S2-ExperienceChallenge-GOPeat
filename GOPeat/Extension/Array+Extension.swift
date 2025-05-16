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

extension Array where Element == Food {
    mutating func sort(using closure: ((Food, Food)->Bool)?) {
        guard let closure = closure else {return}
        self.sort(by: closure)
    }
}
extension Array where Element == Tenant {
    mutating func sort(using closure: ((Tenant,Tenant)->Bool)?) {
        guard let closure = closure else {return}
        self.sort(by: closure)
    }
}
