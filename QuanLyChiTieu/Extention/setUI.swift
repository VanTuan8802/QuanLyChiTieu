//
//  setUI.swift
//  QuanLyChiTieu
//
//  Created by Nguyễn Tuấn on 12/09/2023.
//

import Foundation
import UIKit

extension UIViewController{
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func checkEmail(email : String)->String{
        if email.isEmpty == true{
            return "Bạn chưa điền email"
        }else if email.contains("@") == false || email.contains(".") == false{
            return "Email bạn nhập chưa chính xác"
        }else{
            return ""
        }
    }
    
    func checkPassword(password: String)->String{
        if password.isEmpty{
            return "Password is required"
        }else if password.count < 8 || password.count > 40{
            return "Password has length from 8 to 40"
        }else if password.contains(""){
            return "Password don't have space or tab"
        }else{
            return ""
        }
    }
    
    func setUIButton(button : UIButton){
        button.backgroundColor = UIColor(red: 0.51, green: 0.76, blue: 0.83, alpha: 1.00)
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.titleLabel?.textColor = .black
        button.titleLabel?.font = UIFont(name: "System-Bold", size: 26)
    }
    
    func setUIButtonLogin(button : UIButton){
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.masksToBounds = true
    }
    
    func setUITextField(textField : UITextField){
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.masksToBounds = true
    }
    
    func setUIAvartar(image : UIImageView){
        image.layer.cornerRadius = 60
        image.layer.borderColor = UIColor.black.cgColor
    }
    
    func convertDateToString(date : Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    class func convertStringToDate(from dateString: String)->Int?{
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            if let date = dateFormatter.date(from: dateString) {
                let calendar = Calendar.current
                let month = calendar.component(.month, from: date)
                return month
            }
            
            return nil
    }
}
