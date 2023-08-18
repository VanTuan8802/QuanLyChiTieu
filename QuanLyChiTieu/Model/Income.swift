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
    // đoạn này sẽ convert dữ liệu từ object thành dictionary
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSON.encoder.encode(self))) as? [String: Any] ?? [:]
    }
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    
}

struct IncomeInfor : Codable{
    var name : String
    var date : String
    var value : Float
    
}

struct Income : Codable{
    var name : String
    var sum : Float
    var list : [IncomeInfor]?
    
    init(name: String, sum: Float, list: [IncomeInfor]? = nil) {
        self.name = name
        self.sum = sum
        self.list = list
    }
}


