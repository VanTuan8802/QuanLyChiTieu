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

class SpendingViewController: UIViewController{
    
    @IBOutlet weak var segmentSpending: UISegmentedControl!
    @IBOutlet weak var sumLb: UILabel!
    @IBOutlet weak var spendingTableView: UITableView!
    @IBOutlet weak var addBtn: UIButton!
    
    var month: String  = getNowMonth()
    var lastmonth: String = getLastMonthYear()
    
    private var spendings : [Spending] = []
    private var sum : Float = 0;
    
    let databaseRef = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       loadDataSpending(month: month)
        setupTableView()
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
        spendingTableView.delegate = self
        spendingTableView.dataSource = self
        spendingTableView.register(UINib(nibName: SpendingTableViewCell.id, bundle: nil), forCellReuseIdentifier: SpendingTableViewCell.id)
    }
    
    func loadDataSpending(month : String){
        getDataSpending(month: month){ spendings,sumValue in
            self.spendings = spendings
            self.spendingTableView.reloadData()
            self.sumLb.text = "Tổng chi tiêu là \(sumValue)"

        }
    }

    func addData(spending : Spending ){
        if let currentUser = Auth.auth().currentUser?.uid{
            databaseRef.child(Constant.Key.spending).child(currentUser).child(spending.id).setValue(spending.dictionary)
        }
    }
    
    @IBAction func convertTab(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            loadDataSpending(month: lastmonth)
            addBtn.isHidden = true
        default:
            loadDataSpending(month: month)
            addBtn.isHidden = false
        }
    }
   
    @IBAction func addAction(_ sender: Any) {
        do {
            let alertController = UIAlertController(title: "Thêm khoản chi tiêu", message: "", preferredStyle: UIAlertController.Style.alert)
            
            alertController.addTextField { (textField : UITextField!) -> Void in
                   textField.placeholder = "Nhập tên thu nhập"
               }
            
            alertController.addTextField { (textField : UITextField!) -> Void in
                   textField.placeholder = "Nhập hạn mức"
               }
            
            let okAction = UIAlertAction(title: "OK", style:.default, handler: { [self] alert -> Void in
                let id = UUID().uuidString
                let name = alertController.textFields![0].text ?? ""
                let level = Float(alertController.textFields![1].text ?? "" )
                let month = UIViewController.getNowMonth()
                
                var spendingExist = false
                
                for spending in spendings {
                    if spending.name == name{
                        spendingExist = true
                        break
                    }
                }
                
                if spendingExist{
                    self.showAlert(title: "Error", message: "Đã có khoản chi trong danh sách")
                }else{
                    addData(spending: Spending(id: id, name: name,month: month, sum: 0, lever: level!,list: []))
                    loadDataSpending(month: month)
                }
               })
            let cancelAction = UIAlertAction(title: "Cancel", style:.default, handler: {
                   (action : UIAlertAction!) -> Void in })
               
               alertController.addAction(okAction)
               alertController.addAction(cancelAction)
               
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}

extension SpendingViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spendings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SpendingTableViewCell.id, for: indexPath) as! SpendingTableViewCell
        let spending = spendings[indexPath.row]
        
        cell.bindData(spending: spending)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let incomeInfo = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FinanceViewController") as! FinanceViewController
        incomeInfo.titleLb = spendings[indexPath.row].name
        incomeInfo.id = spendings[indexPath.row].id
        incomeInfo.month = month
        incomeInfo.type = "income"
        navigationController?.pushViewController(incomeInfo, animated: true)
    }
}
