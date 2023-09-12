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
import Foundation

class IncomeViewController: UIViewController {
    
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var sumValue: UILabel!
    @IBOutlet weak var incomeTableView: UITableView!
    @IBOutlet weak var monthSegment: UISegmentedControl!
    
    private var incomes : [Income] = []
    let databaseRef = Database.database().reference()
    var sum : Float = 0;
    
    var month: String  = getNowMonth()
    var lastmonth: String = getLastMonthYear()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        monthSegment.selectedSegmentIndex = 1
        loadData(month: month)
    }
    
    @IBAction func monthSegmentAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            loadData(month: lastmonth)
            addBtn.isHidden = true
        default:
            loadData(month: month)
            addBtn.isHidden = false
        }
    }
    
    private func setupTableView() {
        incomeTableView.delegate = self
        incomeTableView.dataSource = self
        incomeTableView.register(UINib(nibName: "IncomeTableViewCell", bundle: nil), forCellReuseIdentifier: "IncomeTableViewCell")
    }
    
    func loadData(month : String){
        getDataIncome(month: month) { incomes, sumValue in
            self.incomes = incomes
            self.incomeTableView.reloadData()
            self.sum = sumValue
            self.sumValue.text = "Tổng thu nhập là \(sumValue)"
        }
    }

    func addData(income : Income ){
        if let currentUser = Auth.auth().currentUser?.uid{
            databaseRef.child("income").child(currentUser).child(income.id).setValue(income.dictionary)
        }
    }
    
    @IBAction func addAction(_ sender: Any) {
        let alertController = UIAlertController(title: "Thêm khoản thu nhập", message: "", preferredStyle: UIAlertController.Style.alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Nhập tên thu nhập"
        }
        let okAction = UIAlertAction(title: "OK", style:.default, handler: { [self] alert -> Void in
            let id = UUID().uuidString
            let name = alertController.textFields![0].text ?? ""
            let month = UIViewController.getNowMonth()
            
            addData(income: Income(id: id, name: name, month: month, sum: 0,list: []))
            loadData(month: month)
            
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}

extension IncomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let finance = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FinanceViewController") as! FinanceViewController
        finance.titleLb = incomes[indexPath.row].name
        finance.id = incomes[indexPath.row].id
        finance.month = month
        finance.type = "income"
        navigationController?.pushViewController(finance, animated: true)
    }
}
