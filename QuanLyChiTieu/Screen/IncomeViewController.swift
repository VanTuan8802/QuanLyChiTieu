//
//  IncomeViewController.swift
//  QuanLyChiTieu
//
//  Created by Nguyễn Tuấn on 08/08/2023.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class IncomeViewController: UIViewController {

    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var sumValue: UILabel!
    @IBOutlet weak var incomeTableView: UITableView!
    
    var income : Income!
    
    private var incomes : [Income] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        if let currentUser = Auth.auth().currentUser?.uid{
            let incomeRef = Database.database().reference().child("income").child("nowIncome").child(currentUser)
            incomeRef.observeSingleEvent(of: .value, with: { [self] snapshot in
                print(snapshot)
                if let incomeData = snapshot.value as? [String: Any] {
                    //print(incomeData)
//                    let name = data["name"] as? String ?? ""
//                    let sumValue = data["value"] as? Float ?? 0
//
//                    incomes.append(Income(name: name, sum: sumValue))
                   
                }
                self.incomeTableView.reloadData()
            })
            
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       
    }
    
    private func setupTableView() {
        incomeTableView.delegate = self
        incomeTableView.dataSource = self
        incomeTableView.register(UINib(nibName: "IncomeTableViewCell", bundle: nil), forCellReuseIdentifier: "IncomeTableViewCell")
    }
    
    @IBAction func addAction(_ sender: Any) {
        var income : Income
        
        let alertController = UIAlertController(title: "Thêm khoản thu nhập", message: "", preferredStyle: UIAlertController.Style.alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
               textField.placeholder = "Nhập tên thu nhập"
           }
        let okAction = UIAlertAction(title: "OK", style:.default, handler: { alert -> Void in
            let name = alertController.textFields![0] as UITextField
            
            
           })
        let cancelAction = UIAlertAction(title: "Cancel", style:.default, handler: {
               (action : UIAlertAction!) -> Void in })
           
           alertController.addAction(okAction)
           alertController.addAction(cancelAction)
           
        self.present(alertController, animated: true, completion: nil)
    }
}

extension IncomeViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return incomes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IncomeTableViewCell", for: indexPath) as! IncomeTableViewCell
        let income = incomes[indexPath.row]
        
        cell.bindData(income: income)
        return cell
    }
}

extension IncomeViewController: UITableViewDelegate {
    
}
