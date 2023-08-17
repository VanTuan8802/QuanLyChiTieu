//
//  TutorialCollectionViewCell.swift
//  QuanLyChiTieu
//
//  Created by Nguyễn Tuấn on 07/08/2023.
//

import UIKit

class TutorialCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var buttonTutorial: UIButton!
    @IBOutlet weak var imageTutorial: UIImageView!
    
    var nextCallback: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        buttonTutorial.setTitle("Skip", for: .normal)
        imageTutorial.image = nil
        buttonTutorial.layer.cornerRadius = 25
        buttonTutorial.clipsToBounds = true
        
        buttonTutorial.backgroundColor = UIColor(red: 0.51, green: 0.76, blue: 0.83, alpha: 1.00)
        
    }
    
    @IBAction func handleBtnAction(_ sender: Any) {
        nextCallback?()
    }
    
    override func prepareForReuse() {
            super.prepareForReuse()
            imageTutorial.image = nil
        }
        
        func bindData(index: Int, image: String,  nextCallback: (() -> Void)?) {
            if index == 2{
                buttonTutorial.setTitle("Bắt đầu", for: .normal)
            }else{
                buttonTutorial.setTitle("Tiếp tục", for: .normal)
            }
            
            self.nextCallback = nextCallback
            imageTutorial.image = UIImage(named: image)
        }
}
