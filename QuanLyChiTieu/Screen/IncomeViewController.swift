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
    
    @IBOutlet weak var monthSegment: UISegmentedControl!
    
    var month : String!
    var income : Income!
    private var incomes : [Income] = []
    let databaseRef = Database.database().reference()
    var sum : Float = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        monthSegment.selectedSegmentIndex = 1
        month = "nowIncome"
        loadData(month: month)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func monthSegmentAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            month = "lastIncome"
            loadData(month: month)
        default:
            month = "nowIncome"
            loadData(month: month)
        }
    }
    
    private func setupTableView() {
        incomeTableView.delegate = self
        incomeTableView.dataSource = self
        incomeTableView.register(UINib(nibName: "IncomeTableViewCell", bundle: nil), forCellReuseIdentifier: "IncomeTableViewCell")
    }
    
    func loadData(month : String){
        incomes.removeAll()
        sum  = 0
        if let currentUser = Auth.auth().currentUser?.uid{
            databaseRef.child("income").child(month).child(currentUser).observeSingleEvent(of: .value) { [weak self] SnapshotData  in
                guard let strongSelf = self else{
                    return
                }
                
                if let incomeData = SnapshotData.value as? [String:Any]{
                    for(_ , incomeInfo) in incomeData{
                        if let incomeInfoData = incomeInfo as? [String: Any]{
                            let name = incomeInfoData["name"] as? String ?? ""
                            let value = incomeInfoData["value"] as? Float ?? 0
                            self!.sum = self!.sum + value
                            
                            strongSelf.incomes.append(Income(name: name, sum: value))
                        }
                    }
                }
                strongSelf.incomeTableView.reloadData()
                self!.sumValue.text = "Tổng thu nhập là \(self!.sum)"
            }
        }
    }
    
    
    func addData(income : Income ){
        if let currentUser = Auth.auth().currentUser?.uid{
            databaseRef.child("income").child(month).child(currentUser).childByAutoId().setValue(income.dictionary)
        }
    }
    
    @IBAction func addAction(_ sender: Any) {
        var income : Income
        
        let alertController = UIAlertController(title: "Thêm khoản thu nhập", message: "", preferredStyle: UIAlertController.Style.alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
               textField.placeholder = "Nhập tên thu nhập"
           }
        let okAction = UIAlertAction(title: "OK", style:.default, handler: { [self] alert -> Void in
            let name = alertController.textFields![0].text ?? ""
    
           addData(income: Income(name: name, sum:0))
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
    
    
}

extension IncomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let incomeInfo = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "IncomeInfoViewController") as! IncomeInfoViewController
        incomeInfo.titleLb = incomes[indexPath.row].name
        
        navigationController?.pushViewController(incomeInfo, animated: true)
        }
}
