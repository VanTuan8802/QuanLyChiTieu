//
//  ChangePasswordViewController.swift
//  QuanLyChiTieu
//
//  Created by Nguyễn Tuấn on 09/08/2023.
//

import UIKit
import Firebase
import FirebaseAuth

class ChangePasswordViewController: UIViewController {
    @IBOutlet weak var lastPasswordTxt: UITextField!
    @IBOutlet weak var lastPasswordValidate: UILabel!
    @IBOutlet weak var newPasswordTxt: UITextField!
    @IBOutlet weak var newPasswordValidate: UILabel!
    @IBOutlet weak var confirmNewPasswordTxt: UITextField!
    @IBOutlet weak var confirmNewPasswordValidate: UILabel!
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewProfile = storyboard.instantiateViewController(withIdentifier: "AccountViewController")
        let nav = UINavigationController(rootViewController: viewProfile)
        navigationController?.popToViewController(viewProfile, animated: true)
        tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func saveAction(_ sender: Any) {
        if let user = Auth.auth().currentUser {
            let newPassword = "newPasswordHere" // Replace with the new password you want to set

            user.updatePassword(to: newPasswordTxt.text!) { error in
                if let error = error {
                    // Handle error
                    print("Error changing password: \(error.localizedDescription)")
                } else {
                    print("Password changed successfully!")
                }
            }
        }
    }
    
    @IBAction func editLastPasswordEnd(_ sender: Any) {
        lastPasswordValidate.text = checkPassword(password: lastPasswordTxt.text!)
    }
    
    @IBAction func editNewPasswordEnd(_ sender: Any) {
        newPasswordValidate.text = checkPassword(password: newPasswordTxt.text!)
    }
    
    @IBAction func editConfirmNewPasswordEnd(_ sender: Any) {
        confirmNewPasswordValidate.text = checkPassword(password: confirmNewPasswordTxt.text!)
        if confirmNewPasswordTxt.text == newPasswordTxt.text{
            confirmNewPasswordValidate.text = "Confirm password not same password"
        }
    }
    
}
