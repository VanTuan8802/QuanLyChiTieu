//
//  SceneDelegate.swift
//  QuanLyChiTieu
//
//  Created by Nguyễn Tuấn on 07/08/2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        (UIApplication.shared.delegate as? AppDelegate)?.window = window
        
        if UserDefaults.standard.bool(forKey: "tutorialCompleted") {
           
            if UserDefaults.standard.bool(forKey: "isLoggedIn") {
                routeToTabbarController()
            } else {
                routeToLogin()
            }
        }else{
            routeToTutorial()
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

extension SceneDelegate{
    private func routeToLogin(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        let nav = UINavigationController(rootViewController: loginVC)
        nav.setNavigationBarHidden(true, animated: true)
        guard let window = (UIApplication.shared.delegate as? AppDelegate)?.window else{return}
        window.rootViewController = nav
        window.makeKeyAndVisible()
        
    }
    
    //Chuyển đến màn hình main
    private func routeToTabbarController(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let MainVC = storyboard.instantiateViewController(withIdentifier: "TabbarViewController")
        guard let window = (UIApplication.shared.delegate as? AppDelegate)?.window else{
            return
        }
        window.rootViewController = MainVC
        window.makeKeyAndVisible()
        
    }
    
    private func routeToTutorial(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tutorialVC = storyboard.instantiateViewController(withIdentifier: "TutorialViewController")
        guard let window = (UIApplication.shared.delegate as? AppDelegate)?.window else{return}
        window.rootViewController = tutorialVC
        window.makeKeyAndVisible()
    }
}
