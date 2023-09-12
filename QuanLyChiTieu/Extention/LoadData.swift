//
//  Extention.swift
//  QuanLyChiTieu
//
//  Created by Nguyễn Tuấn on 25/08/2023.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

extension UIViewController{
    class func getNowMonth()->String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-yyyy"
        
        let currentDate = Date()
        let currentMonthYearString = dateFormatter.string(from: currentDate)
        
        return currentMonthYearString
    }
    
    class func getLastMonthYear()->String{
        let today = Date()
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: today)
        let currentYear = calendar.component(.year, from: today)
        var lastMonth = currentMonth - 1
        var lastYear = currentYear
        if lastMonth == 0 {
            lastMonth = 12
            lastYear -= 1
        }
        var dateComponents = DateComponents()
        dateComponents.year = lastYear
        dateComponents.month = lastMonth
        if let lastMonthDate = calendar.date(from: dateComponents) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-yyyy"
            let lastMonthString = dateFormatter.string(from: lastMonthDate)
            return lastMonthString
        }
        return ""
    }
    
    func getDataIncome(month: String, completion: @escaping ([Income], Float) -> Void) {
        var incomes: [Income] = []
        var sumValue: Float = 0
        
        if let currentUser = Auth.auth().currentUser?.uid {
            let databaseRef = Database.database().reference()
            let query = databaseRef.child("income").child(currentUser).queryOrdered(byChild: "month").queryEqual(toValue: month)
            
            query.observeSingleEvent(of: .value) { snapshot in
                if let incomeData = snapshot.value as? [String: [String: Any]] {
                    for (incomeId, data) in incomeData {
                        if let name = data["name"] as? String,
                           let month = data["month"] as? String,
                           let sum = data["sum"] as? Float {
                            incomes.append(Income(id: incomeId, name: name, month: month, sum: sum, list: []))
                            sumValue += sum
                        }
                    }
                }
                completion(incomes, sumValue)
            }
        } else {
            completion([], 0)
        }
    }
    
    func getDataSpending(month: String, completion: @escaping ([Spending], Float) -> Void) {
        var spendings : [Spending] = []
        var sumValue : Float = 0
        
        if let currentUser = Auth.auth().currentUser?.uid{
            let databaseRef = Database.database().reference()
            let query = databaseRef.child("spending").child(currentUser).queryOrdered(byChild: "month").queryEqual(toValue: month)
            
            query.observeSingleEvent(of: .value) { [weak self] snapshot, _ in
                guard self != nil else {
                    return
                }
                
                if let spendingData = snapshot.value as? [String: [String: Any]] {
                    print(spendingData)
                    for (spendingId, data) in spendingData {
                        if let month = data["month"] as? String,
                           let name = data["name"] as? String,
                           let lever = data["level"] as? Float,
                           let sum = data["sum"] as? Float {
                            spendings.append(Spending(id: spendingId, name: name, month: month, sum: sum
                                                      , lever: lever,list: []))
                            
                            sumValue += sum
                        }
                    }
                }
                print("as")
                print(spendings.count)
                completion(spendings,sumValue)
            }
        }else{
            completion([],0)
        }
    }
    
    func getDataFinance(type : String, month : String, id : String, completion: @escaping([FinanceInfo],Float)->Void){
        var finances : [FinanceInfo] = []
        var sumValue : Float = 0.0
        let databaseRef = Database.database().reference()
        
        if let currenUser = Auth.auth().currentUser?.uid{
            let query = databaseRef.child(type).child(currenUser).child(id).child("list")
            
            query.observeSingleEvent(of: .value) { snapshot in
                if let financeDatas = snapshot.value as? [String: [String: Any]] {
                    for (id, data) in financeDatas {
                        if let name = data["name"] as? String,
                           let date = data["date"] as? String,
                           let value = data["value"] as? Float{
                            finances.append(FinanceInfo(id:id,name: name, date: date, value: value))
                            sumValue += value
                        }
                    }
                }
                completion(finances,sumValue)
            }
        }else{
            completion([],0)
        }
    }
    
    func findDataFinance(type: String, id : String, name: String, completion: @escaping([FinanceInfo],Float)->Void){
        var finances : [FinanceInfo] = []
        var sumValue : Float = 0.0
        let databaseRef = Database.database().reference()
        
        if let currenUser = Auth.auth().currentUser?.uid{
            let query = databaseRef.child(type).child(currenUser).child(id).child("list").queryOrdered(byChild: "name").queryEqual(toValue: name)
            
            query.observeSingleEvent(of: .value) { snapshot in
                if let financeDatas = snapshot.value as? [String: [String: Any]] {
                    print(financeDatas)
                    for (id, data) in financeDatas {
                        if let name = data["name"] as? String,
                           let date = data["date"] as? String,
                           let value = data["value"] as? Float{
                            print(name)
                            finances.append(FinanceInfo(id:id,name: name, date: date, value: value))
                            sumValue += value
                        }
                    }
                }
                completion(finances,sumValue)
            }
        }else{
            completion([],0)
        }
    }
}
