//
//  SpendingInfoViewController.swift
//  QuanLyChiTieu
//
//  Created by Nguyễn Tuấn on 09/08/2023.
//

import UIKit

class SpendingInfoViewController: UIViewController {

    @IBOutlet weak var headerLb: UILabel!
    
    @IBOutlet weak var financeTableView: UITableView!
    
    @IBOutlet weak var addBtn: UIButton!
    
    
    @IBOutlet weak var sumLB: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addAction(_ sender: Any) {
        let alertController = UIAlertController(title: "Thêm khoản chi tiêu", message: "", preferredStyle: UIAlertController.Style.alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
               textField.placeholder = "Nhập tên thu nhập"
           }
        
        alertController.addTextField { (textField : UITextField!) -> Void in
               textField.placeholder = "Nhập hạn mức"
                textField.keyboardType = .numberPad
           }
        
        let okAction = UIAlertAction(title: "OK", style:.default, handler: { [self] alert -> Void in
            let name = alertController.textFields![0].text ?? ""
            let id = UUID().uuidString
    
//            addData(income: Income(id: id, name: name, sum:0,list: [] ))
            //loadData(month: month)
            
           })
        let cancelAction = UIAlertAction(title: "Cancel", style:.default, handler: {
               (action : UIAlertAction!) -> Void in })
           
           alertController.addAction(okAction)
           alertController.addAction(cancelAction)
           
        self.present(alertController, animated: true, completion: nil)
    }
}
