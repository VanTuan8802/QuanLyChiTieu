//
//  HomeViewController.swift
//  QuanLyChiTieu
//
//  Created by Nguyễn Tuấn on 08/08/2023.
//

import UIKit
import Charts
import Firebase
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController {
    
    @IBOutlet weak var chartIncome: UIView!
    @IBOutlet weak var pieChartView: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentUser = Auth.auth().currentUser?.uid {
            let userRef = Database.database().reference().child("account").child(currentUser)
            userRef.observeSingleEvent(of: .value, with: { snapshot in
                if let userData = snapshot.value as? [String: Any] {
                    let name = userData["name"] as? String ?? ""
                    let userImageUrl = userData["image"] as? String ?? ""
                    
                    UserDefaults.standard.set(name, forKey: "name")
                    UserDefaults.standard.set(userImageUrl, forKey: "image")
                    
                }
            })
        }
        setupPieChart()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setupPieChart(){
        let incomes : [Income] = loadDataIncome(month: "lastIncome").0
        
        var name : [String] = []
        var value : [Float] = []
        
        for income in incomes {
            name.append(income.name)
            value.append(income.sum)
        }
        
        let data : [ChartDataEntry]
    }
}


