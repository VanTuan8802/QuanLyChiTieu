//
//  SpendingTableViewCell.swift
//  QuanLyChiTieu
//
//  Created by Nguyễn Tuấn on 23/08/2023.
//

import UIKit

class SpendingTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var sumLb: UILabel!
    @IBOutlet weak var remainLb: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func resetData() {
        nameLb.text = nil
        sumLb.text = nil
        remainLb.text = nil
    }
    
    func bindData(spending : Spending){
        nameLb.text = spending.name
        sumLb.text = "Tông thu nhập là :\( String(format:"%.2f", spending.sum))"
        remainLb.text = "Số tiền còn lại \( String(format: "%.2f", spending.lever-spending.sum))"
    }
    
}
