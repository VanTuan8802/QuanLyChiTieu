//
//  Income.swift
//  QuanLyChiTieu
//
//  Created by Nguyễn Tuấn on 16/08/2023.
//

import Foundation
struct JSON {
    static let encoder = JSONEncoder()
}

extension Encodable {
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSON.encoder.encode(self))) as? [String: Any] ?? [:]
    }
    
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
}

struct FinanceInfo : Codable{
    var id : String
    var name : String
    var date : String
    var value : Float
    
    init(id: String, name: String, date: String, value: Float) {
        self.id = id
        self.name = name
        self.date = date
        self.value = value
    }
}


struct Income : Codable{
    var id : String
    var name : String
    var month : String
    var sum : Float
    var list : [FinanceInfo]?
    
    init(id: String, name: String, month: String, sum: Float, list: [FinanceInfo]? = nil) {
        self.id = id
        self.name = name
        self.month = month
        self.sum = sum
        self.list = list
    }
}


