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
    
    var month : String = "nowIncome"
    var spending : Spending!
    var spendings : [Spending] = []
    var sum : Float = 0;
    
    let databaseRef = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func setupTableView() {
        spendingTableView.delegate = self
        spendingTableView.dataSource = self
        spendingTableView.register(UINib(nibName: "IncomeTableViewCell", bundle: nil), forCellReuseIdentifier: "IncomeTableViewCell")
    }
    
    func loadData(month : String){
//        spendings.removeAll()
//        sum  = 0
//        if let currentUser = Auth.auth().currentUser?.uid{
//            databaseRef.child("spending").child(month).child(currentUser).observeSingleEvent(of: .value) {  snapshot  in
//                if let spendingData = snapshot.value as? [String:Any]{
//                    for(_ , spendingInfo) in spendingData{
//                        if let spending = spendingInfo as? [String: Any]{
//                            let id = spendingInfo["id"] as? String ?? ""
//                            let name = spendingInfo["name"] as? String ?? ""
//                            let value = spendingInfo["value"] as? Float ?? 0
//                            let lever = spendingInfo["lever"] as? Float ?? 0
//                            self!.sum = self!.sum + value
//                            
//                            self.spendings.append(Spending(id: id, name: name, sum: sum, lever: lever))
//                        }
//                    }
//                }
//                self.spendingTableView.reloadData()
//                self!.sumValue.text = "Tổng thu nhập là \(self!.sum)"
//            }
//        }
    }

    func addData(spending : Spending ){
        if let currentUser = Auth.auth().currentUser?.uid{
            databaseRef.child("spending").child(month).child(currentUser).child(spending.id).setValue(spending.dictionary)
        }
    }
    
    @IBAction func convertTab(_ sender: Any) {
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
        
                addData(spending: Spending(id: id, name: name,month: month, sum: 0, lever: level!,list: []))
                loadData(month: month)
                
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpendingTableViewCell", for: indexPath) as! SpendingTableViewCell
        let spending = spendings[indexPath.row]
        
        cell.bindData(spending: spending)
        return cell
    }
}
