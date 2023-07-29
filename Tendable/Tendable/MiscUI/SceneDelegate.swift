//
//  SceneDelegate.swift
//  Tendable
//
//  Created by Josh Barker on 06/07/2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        // shows the onboarding nav view controller
        guard let windowScrene = (scene as? UIWindowScene) else { return }
        
        var isLoggedIn = UserManager.shared.isUserLoggedIn()
        Logging.JLog(message: "isLoggedIn : \(isLoggedIn)")
        
        if !isLoggedIn {
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginNavController")
            
            let window = UIWindow(windowScene: windowScrene)

            window.rootViewController = initialViewController
            self.window = window
            window.makeKeyAndVisible()
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

        // Save changes in the application's managed object context when the application transitions to the background.
        
        
        
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    static func redirectToMainNavRVC(currentVC: UIViewController){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QuestionsNavViewController") as! UINavigationController
        
        if let scene = UIApplication.shared.connectedScenes.first{

            guard let windowScene = (scene as? UIWindowScene) else { return }

            let window: UIWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)

            window.windowScene = windowScene //Make sure to do this
            window.rootViewController = vc
            window.makeKeyAndVisible()

            appDelegate.window = window
        }
    }

    static func redirectToLoginVC(currentVC: UIViewController){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginNavController") as! UINavigationController
        
        if let scene = UIApplication.shared.connectedScenes.first{

            guard let windowScene = (scene as? UIWindowScene) else { return }

            let window: UIWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)

            window.windowScene = windowScene //Make sure to do this
            window.rootViewController = vc
            window.makeKeyAndVisible()

            appDelegate.window = window
        }
    }
}

