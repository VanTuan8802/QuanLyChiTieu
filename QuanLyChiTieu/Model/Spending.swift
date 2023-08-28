//
//  Spending.swift
//  QuanLyChiTieu
//
//  Created by Nguyễn Tuấn on 16/08/2023.
//

import Foundation


struct Spending :Codable{
    var id : String
    var name : String
    var month : String
    var sum : Float
    var lever : Float
    var list : [FinanceInfo]?
    
    init(id: String, name: String, month: String, sum: Float, lever: Float, list: [FinanceInfo]? = nil) {
        self.id = id
        self.name = name
        self.month = month
        self.sum = sum
        self.lever = lever
        self.list = list
    }
}
