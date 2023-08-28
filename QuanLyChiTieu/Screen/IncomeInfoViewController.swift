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
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var financeInfoTableView: UITableView!
    @IBOutlet weak var addData: UIButton!
    @IBOutlet weak var showSum: UILabel!
    
    let databaseRef = Database.database().reference()
    
    var month = UserDefaults.standard.string(forKey: "month")
    
    var titleLb: String?
    var id :String?
    
    var financeInfo : FinanceInfo!
    
    private var financeInfos: [FinanceInfo] = []
    var sum : Float = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        header.text = titleLb
        
        setupTableView()
        loadDataFinanceInfo(month: month!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let currentUser = Auth.auth().currentUser?.uid{
            let incomeInfoRef = Database.database().reference().child("income").child("nowIncome").child(currentUser).child("listData").childByAutoId()
            incomeInfoRef.observeSingleEvent(of: .value, with: {snapshot in
                if let incomeInfoData = snapshot.value as? [String: Any] {
                    let name = incomeInfoData["name"] as? String ?? ""
                    let date = incomeInfoData["date"] as? String ?? "1/1/2023"
                    let value = incomeInfoData["value"] as? Float ?? 0
                    
                    self.financeInfo = FinanceInfo(name: name, date: date, value: value)
                }
                self.financeInfoTableView.reloadData()
            })
        }
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
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "VN")
        alertController.view.addSubview(datePicker)
        
        let okAction = UIAlertAction(title: "OK", style:.default, handler: { [self] alert -> Void in
            
            let name = alertController.textFields![0].text ?? ""
            let date = convertDateToString(date: datePicker.date)
            let value = Float(alertController.textFields![1].text ?? "")
            
            print(FinanceInfo(name: name, date: date, value: value!))
            addDataFinance(finance: FinanceInfo(name: name, date: date, value: value!))
            loadDataFinanceInfo(month: UserDefaults.standard.string(forKey: "month")!)
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style:.default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func loadDataFinanceInfo(month: String) {
        financeInfos.removeAll()
        sum = 0
        
        if let currentUser = Auth.auth().currentUser?.uid{
            databaseRef.child("income").child(month).child(currentUser).child(id!).child("list").observeSingleEvent(of: .value) { [weak self] SnapshotData,_   in
                guard let strongSelf = self else{
                    return
                }
                
                if let incomeData = SnapshotData.value as? [String:Any]{
                    
                    for(_ , financeValues) in incomeData{
                        if let financeValue = financeValues as? [String: Any]{
                            let name = financeValue["name"] as? String ?? ""
                            let date = financeValue["date"] as? String ?? ""
                            let value = financeValue["value"] as? Float ?? 0.0
                            self!.sum = self!.sum + value
                            
                            strongSelf.financeInfos.append(FinanceInfo(name: name, date: date, value: value))
                        }
                    }
                }
                               strongSelf.financeInfoTableView.reloadData()
                               self!.showSum.text = "Tổng thu nhập là \(self!.sum)"
            }
        }
    }
    
    func addDataFinance(finance : FinanceInfo ){
        if let currentUser = Auth.auth().currentUser?.uid{
            databaseRef.child("income").child(month!).child(currentUser).child(id!).child("list").childByAutoId().setValue(finance.dictionary)
        }
    }
    
}

extension IncomeInfoViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return financeInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FinanceInfoTableViewCell", for: indexPath) as! FinanceInfoTableViewCell
        let financeInfo = financeInfos[indexPath.row]
        
        cell.bindData(financeInfo: financeInfo)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}

extension IncomeInfoViewController: UITableViewDelegate {
    
}
