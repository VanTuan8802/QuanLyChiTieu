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
    
    @IBOutlet weak var rememberPasswordBtn: UIButton!
    @IBOutlet weak var hidePassword: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginGoogleBtn: UIButton!
    @IBOutlet weak var loginFacebookBtn: UIButton!
    @IBOutlet weak var loginAppleBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    var showPassword:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTxt.isSecureTextEntry = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        setUI()
        
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func registerAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let registerVC = storyboard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    @IBAction func loginGoogleAction(_ sender: Any) {
    }
    
    @IBAction func loginFacebookAction(_ sender: Any) {
    }
    
    @IBAction func loginAppleAction(_ sender: Any) {
    }
    
    @IBAction func loginAction(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTxt.text!, password: passwordTxt.text!){ [self]authResult,error in
            if(error != nil){
                self.showAlert(title: "Error", message:error?.localizedDescription ?? "Exception")
            }else{
                authResult?.user.reload(completion: { (error) in
                    if authResult?.user.isEmailVerified == true{
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "TabbarViewController")
                        
                        let keyWindow = UIApplication.shared.connectedScenes
                            .filter({$0.activationState == .foregroundActive})
                            .compactMap({$0 as? UIWindowScene})
                            .first?.windows
                            .filter({$0.isKeyWindow}).first
                        
                        keyWindow?.rootViewController = vc
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        UserDefaults.standard.set(self.emailTxt.text, forKey: "email")
                    }else{
                        self.showAlert(title: "Error", message: "Tài khoản chưa được xác thực")
                    }
                    
                })
                
            }
        }
    }
    
    @IBAction func showPassword(_ sender: Any) {
        showPassword = !showPassword
        
        if showPassword{
            passwordTxt.isSecureTextEntry = false
            hidePassword.setImage(UIImage(named: "visible"), for: .normal)
        }else{
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
    }
    
    func setUI(){
        emailValidate.isHidden = true
        passwordValidate.isHidden = true
        
        setUITextField(textField: emailTxt)
        setUITextField(textField: passwordTxt)
        
        setUIButtonLogin(button: loginGoogleBtn)
        setUIButtonLogin(button: loginFacebookBtn)
        setUIButtonLogin(button: loginAppleBtn)
        
        setUIButton(button: loginBtn)
    }
}

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
}
