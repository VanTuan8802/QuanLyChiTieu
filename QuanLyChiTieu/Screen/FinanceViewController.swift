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
    
    private var finances: [FinanceInfo] = []
    
    private var searchFinance: [FinanceInfo] = [] {
        didSet {
            financeInfoTableView.reloadData()
        }
    }
    
    var titleLb: String!
    
    var month : String!
    var type : String!
    var id :String!
    
    var sum : Float? = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        header.text = titleLb
        setupTableView()
        loadDataFinanceInfo()
        searchFinance = finances
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    private func setupTableView() {
        financeInfoTableView.delegate = self
        financeInfoTableView.dataSource = self
        financeInfoTableView.register(UINib(nibName: "FinanceInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "FinanceInfoTableViewCell")
    }
    
    private func loadDataFinanceInfo() {
        getDataFinance(type: type, month: month, id: id) { [self] financeInfos, sum in
            self.finances = financeInfos
            self.searchFinance = financeInfos
            self.sum = sum
            self.showSum.text = "Tổng \( titleLb ?? "0.0" ) là : \(sum)"
        }
    }
    
    private func addDataFinance(finance : FinanceInfo ){
        if let currentUser = Auth.auth().currentUser?.uid{
            let databaseRef = Database.database().reference()
            databaseRef.child(Constant.Key.income).child(currentUser).child(id!).child("list").childByAutoId().setValue(finance.dictionary)
            
            let updatedValue = ["sum": self.sum]
            databaseRef.child(Constant.Key.spending).child(currentUser)
            
            databaseRef.child("income").child(currentUser).child(id).updateChildValues(updatedValue as [AnyHashable : Any]) { (error, ref) in
                if let error = error {
                    print("Error updating value: \(error.localizedDescription)")
                } else {
                    print("Value updated successfully!")
                }
            }
        }
    }

    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
    
}

extension FinanceViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchFinance.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FinanceInfoTableViewCell", for: indexPath) as! FinanceInfoTableViewCell
        let financeInfo = searchFinance[indexPath.row]
        
        cell.bindData(financeInfo: financeInfo)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}

extension FinanceViewController: UITableViewDelegate {
    
}

extension FinanceViewController: UISearchBarDelegate{
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchFinance = finances
        } else {
            searchFinance = finances.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        financeInfoTableView.reloadData()
    }
}
