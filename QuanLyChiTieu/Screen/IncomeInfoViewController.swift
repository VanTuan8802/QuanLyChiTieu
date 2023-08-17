//
//  IncomeInfoViewController.swift
//  QuanLyChiTieu
//
//  Created by Nguyễn Tuấn on 09/08/2023.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class IncomeInfoViewController: UIViewController{
    
    @IBOutlet weak var header: UILabel!
    
    @IBOutlet weak var incomeInfoTableView: UITableView!
    
    var incomeInfo : IncomeInfor!
    
    private var incomeInfos: [IncomeInfor]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let currentUser = Auth.auth().currentUser?.uid{
            let incomeInfoRef = Database.database().reference().child("income").child("nowIncome").child(currentUser).child("listData")
            incomeInfoRef.observeSingleEvent(of: .value, with: {snapshot in
                if let incomeInfoData = snapshot.value as? [String: Any] {
                    let name = incomeInfoData["name"] as? String ?? ""
                    let date = incomeInfoData["date"] as? String ?? "1/1/2023"
                    let value = incomeInfoData["value"] as? Float ?? 0
                    
                    self.incomeInfo = IncomeInfor(name: name, date: date, value: value)
                }
                self.incomeInfoTableView.reloadData()
            })
            
        }
    }
    
    private func setupTableView() {
        incomeInfoTableView.delegate = self
        incomeInfoTableView.dataSource = self
        incomeInfoTableView.register(UINib(nibName: "IncomeInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "IncomeInfoTableViewCell")
    }
    
}

extension IncomeInfoViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return incomeInfos!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IncomeInfoTableViewCell", for: indexPath) as! IncomeInfoTableViewCell
        let incomeInfo = incomeInfos![indexPath.row]
        
        cell.bindData(incomeInfor: incomeInfo)
        return cell
    }
}

extension IncomeInfoViewController: UITableViewDelegate {
    
}
