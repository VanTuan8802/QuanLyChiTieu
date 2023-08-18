//
//  ManageAccountViewController.swift
//  QuanLyChiTieu
//
//  Created by Nguyễn Tuấn on 09/08/2023.
//

import UIKit
import Firebase
import FirebaseAuth

class ManageAccountViewController: UIViewController, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var changePasswod: UIView!
    @IBOutlet weak var logOutBtn: UIButton!
    @IBOutlet weak var deleteAccountBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var changeNameBtn: UIButton!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var changeImageBtn: UIButton!
    
    private var userImagePicker: UIImagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureChangePassword = UITapGestureRecognizer(target: self, action: #selector(goToChangePassword))
        
        tapGestureChangePassword.delegate = self
        
        changePasswod.addGestureRecognizer(tapGestureChangePassword)
        
        setUI()
    }
    
    @IBAction func logOutAction(_ sender: Any) {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            
            // Xoá thông tin đăng nhập lưu trữ bằng UserDefaults
            UserDefaults.standard.removeObject(forKey: "isLoggedIn")
            UserDefaults.standard.removeObject(forKey: "email")
            
            // Điều hướng người dùng đến màn hình đăng nhập
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                appDelegate.window?.rootViewController = loginVC
            }
        }catch{
            self.showAlert(title: "Error", message: "Logout failure")
        }
    }
    
    @IBAction func changeImageAction(_ sender: Any) {
        userImagePicker.delegate = self
        userImagePicker.sourceType = .photoLibrary
        userImagePicker.allowsEditing = false
        
    }
    
    @IBAction func changeNameTxt(_ sender: Any) {
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteAccountAction(_ sender: Any) {
        if let account = Auth.auth().currentUser {
            account.delete { error in
                if let error = error {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                } else {
                    self.showAlert(title: "Success", message: "Account delete succesfull")
                }
            }
        }
    }
    
    @objc func goToChangePassword(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let changePassword = storyboard.instantiateViewController(withIdentifier: "ChangePasswordViewController")
        navigationController?.pushViewController(changePassword, animated: true)
    }
    
    func setUI(){
        nameTxt.isEnabled = true
        nameTxt.borderStyle = .none
        
        setUIAvartar(image: image)
        
        email.text = UserDefaults.standard.string(forKey: "email")
        nameTxt.text = UserDefaults.standard.string(forKey: "name")
        
        setUIButton(button: logOutBtn)
        setUIButton(button: deleteAccountBtn)
    }
}


