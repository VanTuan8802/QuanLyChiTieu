//
//  Income.swift
//  QuanLyChiTieu
//
//  Created by Nguyễn Tuấn on 16/08/2023.
//

import Foundation

struct IncomeInfor{
    var name : String
    var date : Date
    var value : Float
}

struct Income{
    var name : String
    var sum : Float
    var list : [IncomeInfor]
}


