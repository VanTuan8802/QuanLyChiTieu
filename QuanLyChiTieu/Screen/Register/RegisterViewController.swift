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
    
    var showPassword: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let tabbar = mainStoryboard.instantiateViewController(withIdentifier: "TabbarViewController") as! TabbarViewController
                tabbar.modalPresentationStyle = .fullScreen
                self.present(tabbar, animated: true)
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                
            }
        }
    }
    @IBAction func loginAction(_ sender: Any) {
        
    }
    
}
