//
//  Spending.swift
//  QuanLyChiTieu
//
//  Created by Nguyễn Tuấn on 16/08/2023.
//

import Foundation

struct SpendingInfor{
    var name : String
    var date : Date
    var value : Float
}

struct Spending{
    var name : String
    var sum : Float
    var lever : Float
    var list : [Spending]
}
