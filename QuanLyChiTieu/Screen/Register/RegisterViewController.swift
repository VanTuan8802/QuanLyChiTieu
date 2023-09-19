//
//  RegisterViewController.swift
//  QuanLyChiTieu
//
//  Created by Nguyễn Tuấn on 08/08/2023.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase
import Foundation

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var nameValidate: UILabel!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var emailValidate: UILabel!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var passwordValidate: UILabel!
    @IBOutlet weak var confirmPasswordTxt: UITextField!
    @IBOutlet weak var confirmPasswordValidate: UILabel!
    
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
   
    var account: ((String, String) -> Void)?
    let databaseRef = Database.database().reference()
    var showPassword: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

    func setUI(){
        nameValidate.isHidden = true
        emailValidate.isHidden = true
        passwordValidate.isHidden = true
        confirmPasswordValidate.isHidden = true
        
        passwordTxt.isSecureTextEntry = true
        confirmPasswordTxt.isSecureTextEntry = true
        
        setUITextField(textField: nameTxt)
        setUITextField(textField: emailTxt)
        setUITextField(textField: passwordTxt)
        setUITextField(textField: confirmPasswordTxt)
        
        setUIButton(button: registerBtn)
    }
    
    @IBAction func registerAction(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailTxt.text!, password: passwordTxt.text!){authResult , error in
            if(error != nil) {
                let alert = UIAlertController(title: "Error", message:error?.localizedDescription ?? "Exception", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)
            }else{
                authResult?.user.sendEmailVerification(completion: { (error) in
                    if (error != nil){
                        let alert = UIAlertController(title: "Error", message:error?.localizedDescription ?? "Exception", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                            NSLog("The \"OK\" alert occured.")
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }else{
                        let alert = UIAlertController(title: "", message:"Go to Email to verify link" , preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [self] (action: UIAlertAction!) in
                            navigationController?.popViewController(animated: true)
                            let email = emailTxt.text!
                            let password = passwordTxt.text!
                            account?(email,password)
                            
                            var accountUser = Account(name: nameTxt.text!, image: Constant.Key.imageNil)
                            
                            if let currentUser = Auth.auth().currentUser?.uid{
                                databaseRef.child(Constant.Key.account).child(currentUser).setValue(accountUser.dictionary)
                            }
                        }))
                        
                        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                })
            }
        }
    }
    
    @IBAction func loginAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editName(_ sender: Any) {
        nameValidate.isHidden = true
    }
    
    @IBAction func showNameErrorValidate(_ sender: Any) {
        if nameTxt.text?.isEmpty == true {
            nameValidate.text = "Họ tên không được trống"
        }else{
            nameValidate.isHidden = true
        }
    }
    
    @IBAction func editEmail(_ sender: Any) {
        emailValidate.isHidden = true
    }
    
    @IBAction func showEmailErrorValidate(_ sender: Any) {
        emailValidate.isHidden = false
        emailValidate.text = checkEmail(email: emailTxt.text!)
        emailTxt.layer.cornerRadius = 15
    }
    
    @IBAction func editPassword(_ sender: Any) {
        passwordValidate.isHidden = true
    }
    
    @IBAction func showPasswordErrorValidate(_ sender: Any) {
        passwordValidate.isHidden = false
        passwordValidate.text = checkPassword(password: passwordTxt.text!)
        passwordTxt.layer.cornerRadius = 15
    }
    
    @IBAction func editConfirmPassword(_ sender: Any) {
    }
    
    @IBAction func showConfirmPasswordErrorValidate(_ sender: Any) {
        confirmPasswordValidate.isHidden = false
        confirmPasswordValidate.text = checkPassword(password: confirmPasswordTxt.text!)
        confirmPasswordTxt.layer.cornerRadius = 15
    }
}
