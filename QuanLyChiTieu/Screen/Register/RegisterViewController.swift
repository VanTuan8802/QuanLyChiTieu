//
//  RegisterViewController.swift
//  QuanLyChiTieu
//
//  Created by Nguyễn Tuấn on 08/08/2023.
//

import UIKit
import FirebaseAuth

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
    
    var showPassword: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
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
                            
                            if let accountdata = account,
                               let email = emailTxt.text,
                               let password = passwordTxt.text{
                                    accountdata(email,password)
                            }
                            navigationController?.popViewController(animated: true)
                        }))
                        
                        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                            print("Handle Cancel Logic here")
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                })
                
            }
        }
    }
    @IBAction func loginAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let login = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        let nav = UINavigationController(rootViewController: login)
        nav.setNavigationBarHidden(true, animated: true)
        (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController = nav
        (UIApplication.shared.delegate as? AppDelegate)?.window?.makeKeyAndVisible()
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
        
        nameValidate.isHidden = true
        emailValidate.isHidden = true
        passwordValidate.isHidden = true
        confirmPasswordValidate.isHidden = true
        
        setUIButton(button: registerBtn)
        
    }
}
