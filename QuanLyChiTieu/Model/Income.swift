//
//  Income.swift
//  QuanLyChiTieu
//
//  Created by Nguyễn Tuấn on 16/08/2023.
//

import Foundation

struct IncomeInfor{
    var name : String
    var date : String
    var value : Float
}

struct Income{
    var name : String
    var sum : Float
    var list : [IncomeInfor]?
    
    init(name: String, sum: Float, list: [IncomeInfor]? = nil) {
        self.name = name
        self.sum = sum
        self.list = list
    }
}


