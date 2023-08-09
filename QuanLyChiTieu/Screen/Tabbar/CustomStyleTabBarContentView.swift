//
//  CustomStyleTabBarContentView.swift
//  QuanLyChiTieu
//
//  Created by Nguyễn Tuấn on 08/08/2023.
//

import Foundation
import ESTabBarController_swift

class CustomStyleTabBarContentView: ESTabBarItemContentView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        /// Normal
        textColor = UIColor.black
        iconColor = UIColor.black
        
        /// Selected
        highlightTextColor = UIColor(red: 0.925, green: 0.42, blue: 0.588, alpha: 1)
        highlightIconColor = UIColor(red: 0.925, green: 0.42, blue: 0.588, alpha: 1)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
