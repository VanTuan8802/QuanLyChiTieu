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
    
        setUI()
        
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
        let vc = storyboard.instantiateViewController(withIdentifier: "ManageAccountViewController")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func goToSetting(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SettingViewController")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func goToProduce(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProduceViewController")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setUI(){
        setUIAvartar(image: imageAccount)
        
        emailAccont.text = UserDefaults.standard.string(forKey: "email")
        nameAccount.text = UserDefaults.standard.string(forKey: "name")

    }
}
