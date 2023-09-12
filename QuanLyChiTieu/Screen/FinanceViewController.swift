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

class FinanceViewController: UIViewController{
    
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var financeInfoTableView: UITableView!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var seachBar: UISearchBar!
    @IBOutlet weak var showSum: UILabel!
    
    var finances :[FinanceInfo] = []
    var titleLb: String!
    
    var month : String!
    var type : String!
    var id :String!
    
    var sum : Float? = 0.0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        header.text = titleLb
        setupTableView()
        loadDataFinanceInfo()
    }

    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupTableView() {
        financeInfoTableView.delegate = self
        financeInfoTableView.dataSource = self
        financeInfoTableView.register(UINib(nibName: "FinanceInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "FinanceInfoTableViewCell")
    }
    
    @IBAction func addAction(_ sender: Any) {
        let alertController = UIAlertController(title: "Enter Details", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Nhập tên khoản thu"
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Số tiền"
            textField.keyboardType = .numberPad
        }
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let okAction = UIAlertAction(title: "OK", style:.default, handler: { [self] alert -> Void in
            let id = UUID().uuidString
            let name = alertController.textFields![0].text ?? ""
            let date = dateFormatter.string(from: currentDate)
            let value = Float(alertController.textFields![1].text ?? "")
            addDataFinance(finance: FinanceInfo(id:id,name: name, date: date, value: value!))
            loadDataFinanceInfo()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style:.default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func loadDataFinanceInfo() {
        getDataFinance(type: type, month: month, id: id) { [self] financeInfos, sum in
            self.finances = financeInfos
            self.financeInfoTableView.reloadData()
            self.sum = sum
            self.showSum.text = "Tổng \( titleLb ?? "0.0" ) là : \(sum)"
        }
    }
    
    func addDataFinance(finance : FinanceInfo ){
        if let currentUser = Auth.auth().currentUser?.uid{
            let databaseRef = Database.database().reference()
            databaseRef.child("income").child(currentUser).child(id!).child("list").childByAutoId().setValue(finance.dictionary)
            
            let updatedValue = ["sum": self.sum]
            databaseRef.child("income").child(currentUser).child(id).updateChildValues(updatedValue as [AnyHashable : Any]) { (error, ref) in
                if let error = error {
                    print("Error updating value: \(error.localizedDescription)")
                } else {
                    print("Value updated successfully!")
                }
            }
        }
    }
}

extension FinanceViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return finances.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FinanceInfoTableViewCell", for: indexPath) as! FinanceInfoTableViewCell
        let financeInfo = finances[indexPath.row]
        
        cell.bindData(financeInfo: financeInfo)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}

extension FinanceViewController: UITableViewDelegate {
    
}
