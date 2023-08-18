//
//  IncomeTableViewCell.swift
//  QuanLyChiTieu
//
//  Created by Nguyễn Tuấn on 16/08/2023.
//

import UIKit

class IncomeTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var value: UILabel!
    
    var tapGesture: UITapGestureRecognizer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

    private func resetData() {
        name.text = nil
        value.text = nil
    }
    
    func bindData(income : Income){
        name.text = income.name
        value.text = String(format:"%.2f", income.sum)
    }
}
