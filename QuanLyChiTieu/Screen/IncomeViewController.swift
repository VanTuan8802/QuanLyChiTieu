//
//  IncomeViewController.swift
//  QuanLyChiTieu
//
//  Created by Nguyễn Tuấn on 08/08/2023.
//

import UIKit

class IncomeViewController: UIViewController {

    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var sumValue: UILabel!
    @IBOutlet weak var incomeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
