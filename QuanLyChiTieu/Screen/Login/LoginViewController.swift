//
//  LoginViewController.swift
//  QuanLyChiTieu
//
//  Created by Nguyễn Tuấn on 08/08/2023.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var emailValidate: UILabel!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var passwordValidate: UILabel!
    
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    @IBOutlet weak var rememberPasswordBtn: UIButton!
    @IBOutlet weak var hidePassword: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginGoogleBtn: UIButton!
    @IBOutlet weak var loginFacebookBtn: UIButton!
    @IBOutlet weak var loginAppleBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    private var showPassword: Bool = false
    var account: ((String, String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    func setUI() {
        emailValidate.isHidden = true
        passwordValidate.isHidden = true
        passwordTxt.isSecureTextEntry = true
        
        setUITextField(textField: emailTxt)
        setUITextField(textField: passwordTxt)
        
        setUIButtonLogin(button: loginGoogleBtn)
        setUIButtonLogin(button: loginFacebookBtn)
        setUIButtonLogin(button: loginAppleBtn)
        
        setUIButton(button: loginBtn)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func registerAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let registerVC = storyboard.instantiateViewController(withIdentifier: RegisterViewController.id) as! RegisterViewController
        registerVC.account = { email, password in
            self.emailTxt.text = email
            self.passwordTxt.text = password
        }
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    @IBAction func loginGoogleAction(_ sender: Any) {
        // Add Google login logic here
    }
    
    @IBAction func loginFacebookAction(_ sender: Any) {
        // Add Facebook login logic here
    }
    
    @IBAction func loginAppleAction(_ sender: Any) {
        // Add Apple login logic here
    }
    
    @IBAction func loginAction(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTxt.text!, password: passwordTxt.text!) { [self] authResult, error in
            if error != nil {
                self.showAlert(title: "Error", message: error?.localizedDescription ?? "Exception")
            } else {
                authResult?.user.reload(completion: { error in
                    if authResult?.user.isEmailVerified == true {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: TabbarViewController.id)
                        
                        let keyWindow = UIApplication.shared.connectedScenes
                            .filter({ $0.activationState == .foregroundActive })
                            .compactMap({ $0 as? UIWindowScene })
                            .first?.windows
                            .filter({ $0.isKeyWindow }).first
                        
                        keyWindow?.rootViewController = vc
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        UserDefaults.standard.set(self.emailTxt.text, forKey: "email")
                    } else {
                        self.showAlert(title: "Error", message: "Tài khoản chưa được xác thực")
                    }
                })
            }
        }
    }
    
    @IBAction func showPassword(_ sender: Any) {
        showPassword = !showPassword
        
        if showPassword {
            passwordTxt.isSecureTextEntry = false
            hidePassword.setImage(UIImage(named: "visible"), for: .normal)
        } else {
            passwordTxt.isSecureTextEntry = true
            hidePassword.setImage(UIImage(named: "hidden"), for: .normal)
        }
    }
    
    @IBAction func showEmailValidate(_ sender: Any) {
        emailValidate.isHidden = false
        emailValidate.text = checkEmail(email: emailTxt.text!)
        emailTxt.layer.cornerRadius = 15
    }
    
    @IBAction func editEmailTxt(_ sender: Any) {
        emailValidate.isHidden = true
    }
    
    @IBAction func editPasswordTxt(_ sender: Any) {
        passwordValidate.isHidden = true
    }
    
    @IBAction func showPasswordValidate(_ sender: Any) {
        passwordValidate.isHidden = false
        passwordValidate.text = checkPassword(password: passwordTxt.text!)
        passwordTxt.layer.cornerRadius = 15
    }
    
    @IBAction func rememberAction(_ sender: Any) {
        // Handle remember action
    }
    
    @IBAction func forgotPasswordAction(_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: emailTxt.text!) { [self] error in
            if let error = error {
                print("Error sending password reset email: \(error.localizedDescription)")
            } else {
                print("Password reset email sent to \(emailTxt.text!)")
            }
        }
    }
}
