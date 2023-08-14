//
//  SettingViewController.swift
//  QuanLyChiTieu
//
//  Created by Nguyễn Tuấn on 09/08/2023.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.navigationItem.hidesBackButton = false
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.hidesBackButton = false
    }

    @IBAction func backAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewProfile = storyboard.instantiateViewController(withIdentifier: "AccountViewController")
        let nav = UINavigationController(rootViewController: viewProfile)
        nav.setNavigationBarHidden(true, animated: true)
        (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController = nav
        (UIApplication.shared.delegate as? AppDelegate)?.window?.makeKeyAndVisible()
    }
}
