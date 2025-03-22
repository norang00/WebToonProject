//
//  SceneDelegate.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/19/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        window?.rootViewController = SceneDelegate.createMainTabBarController()
        window?.makeKeyAndVisible()
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

    // MARK: - TabBarController
    static func createMainTabBarController() -> UITabBarController {
        let recommendVC = UINavigationController(rootViewController: RecommendViewController())
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        let likeVC = UINavigationController(rootViewController: LikeViewController())

        let tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = .black
        tabBarController.setViewControllers([recommendVC, searchVC, likeVC], animated: true)
        tabBarController.tabBar.items![0].title = Resources.Keys.recommend.localized
        tabBarController.tabBar.items![0].image = UIImage(systemName: Resources.SystemImage.recommend.rawValue)
        tabBarController.tabBar.items![1].title = Resources.Keys.search.localized
        tabBarController.tabBar.items![1].image = UIImage(systemName: Resources.SystemImage.search.rawValue)
        tabBarController.tabBar.items![2].title = Resources.Keys.like.localized
        tabBarController.tabBar.items![2].image = UIImage(systemName: Resources.SystemImage.like.rawValue)
        
        // [Temp]
        tabBarController.selectedIndex = 0
        
        return tabBarController
    }
}
