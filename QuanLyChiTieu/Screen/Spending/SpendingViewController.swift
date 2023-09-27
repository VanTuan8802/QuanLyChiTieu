//
//  SpendingViewController.swift
//  QuanLyChiTieu
//
//  Created by Nguyễn Tuấn on 08/08/2023.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class SpendingViewController: UIViewController {
    
    @IBOutlet weak var segmentSpending: UISegmentedControl!
    @IBOutlet weak var sumLb: UILabel!
    @IBOutlet weak var spendingTableView: UITableView!
    @IBOutlet weak var addBtn: UIButton!
    
    var month: String = getNowMonth()
    var lastMonth: String = getLastMonthYear()
    
    private var spendings: [Spending] = []
    private var sum: Float = 0
    
    let databaseRef = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentSpending.selectedSegmentIndex = 1
        loadDataSpending(month: month)
        setupTableView()
    }
    
    private func setupTableView() {
        spendingTableView.delegate = self
        spendingTableView.dataSource = self
        spendingTableView.register(UINib(nibName: SpendingTableViewCell.id, bundle: nil), forCellReuseIdentifier: SpendingTableViewCell.id)
    }
    
    func loadDataSpending(month: String) {
        getDataSpending(month: month) { spendings, sumValue in
            self.spendings = spendings
            self.spendingTableView.reloadData()
            self.sumLb.text = "Tổng chi tiêu là \(sumValue)"
        }
    }
    
    func addData(spending: Spending) {
        if let currentUser = Auth.auth().currentUser?.uid {
            databaseRef.child(Constant.Key.spending).child(currentUser).child(spending.id).setValue(spending.dictionary)
        }
    }
    
    @IBAction func monthSegmentAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            loadDataSpending(month: lastMonth)
            addBtn.isHidden = true
        default:
            loadDataSpending(month: month)
            addBtn.isHidden = false
        }
    }
    
    @IBAction func addAction(_ sender: Any) {
        let alertController = UIAlertController(title: "Thêm khoản chi tiêu", message: "", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Nhập tên chi tiêu"
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Nhập hạn mức"
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { [self] _ in
            let id = UUID().uuidString
            let name = alertController.textFields?[0].text ?? ""
            let level = Float(alertController.textFields?[1].text ?? "")
            let month = UIViewController.getNowMonth()
            
            var spendingExists = false
            
            for spending in spendings {
                if spending.name == name {
                    spendingExists = true
                    break
                }
            }
            
            if spendingExists {
                self.showAlert(title: "Error", message: "Đã có khoản chi trong danh sách")
            } else {
                addData(spending: Spending(id: id, name: name, month: month, sum: 0, lever: level ?? 0, list: []))
                loadDataSpending(month: month)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

extension SpendingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spendings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SpendingTableViewCell.id, for: indexPath) as! SpendingTableViewCell
        let spending = spendings[indexPath.row]
        
        cell.bindData(spending: spending)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}

extension SpendingViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let finance = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FinanceViewController") as! FinanceViewController
        finance.titleLb = spendings[indexPath.row].name
        finance.id = spendings[indexPath.row].id
        finance.month = month
        finance.type = "spending"
        navigationController?.pushViewController(finance, animated: true)
    }
}
