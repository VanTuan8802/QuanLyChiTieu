//
//  IncomeInfoTableViewCell.swift
//  QuanLyChiTieu
//
//  Created by Nguyễn Tuấn on 16/08/2023.
//

import UIKit
import Foundation

class IncomeInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var value: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }
    
    private func resetData() {
        name.text = nil
        date.text = nil
        value.text = nil
    }
    
    func bindData(incomeInfor : IncomeInfor){
        name.text = incomeInfor.name
        
        date.text = incomeInfor.date
        value.text = String(format:"%.2f", incomeInfor.value)
    }
}
