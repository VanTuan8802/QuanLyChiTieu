//
//  AccountViewController.swift
//  QuanLyChiTieu
//
//  Created by Nguyễn Tuấn on 08/08/2023.
//

import UIKit

class AccountViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var imageAccount: UIImageView!
    @IBOutlet weak var nameAccount: UILabel!
    @IBOutlet weak var emailAccont: UILabel!
    
    @IBOutlet weak var manageAccount: UIView!
    @IBOutlet weak var setting: UIView!
    @IBOutlet weak var produce: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailAccont.text = UserDefaults.standard.string(forKey: "email")
        nameAccount.text = UserDefaults.standard.string(forKey: "name")

        
        let tapGestureManageAccount = UITapGestureRecognizer(target: self, action: #selector(goToManageAccount))
        let tapGestureSetting = UITapGestureRecognizer(target: self, action: #selector(goToSetting))
        let tapGestureProduce = UITapGestureRecognizer(target: self, action: #selector(goToProduce))
        
        tapGestureManageAccount.delegate = self
        tapGestureSetting.delegate = self
        tapGestureProduce.delegate = self
        
        manageAccount.addGestureRecognizer(tapGestureManageAccount)
        setting.addGestureRecognizer(tapGestureSetting)
        produce.addGestureRecognizer(tapGestureProduce)
    }
    
    
    
    @objc func goToManageAccount(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewProfile = storyboard.instantiateViewController(withIdentifier: "ManageAccountViewController")
        navigationController?.pushViewController(viewProfile, animated: true)
    }
    
    @objc func goToSetting(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewProfile = storyboard.instantiateViewController(withIdentifier: "SettingViewController")
        let nav = UINavigationController(rootViewController: viewProfile)
        nav.setNavigationBarHidden(true, animated: true)
        (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController = nav
        (UIApplication.shared.delegate as? AppDelegate)?.window?.makeKeyAndVisible()
    }
    
    @objc func goToProduce(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewProfile = storyboard.instantiateViewController(withIdentifier: "ProduceViewController")
        let nav = UINavigationController(rootViewController: viewProfile)
        nav.setNavigationBarHidden(true, animated: true)
        (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController = nav
        (UIApplication.shared.delegate as? AppDelegate)?.window?.makeKeyAndVisible()
    }
}
