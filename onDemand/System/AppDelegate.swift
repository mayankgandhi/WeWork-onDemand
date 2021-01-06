//
//  AppDelegate.swift
//  onDemand
//
//  Created by Mayank Gandhi on 12/20/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var coordinator: MainCoordinator?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
      // create the main navigation controller to be used for our app
      let navController = UINavigationController()

      // send that into our coordinator so that it can display view controllers
      coordinator = MainCoordinator(navigationController: navController)

      // tell the coordinator to take over control
      coordinator?.start()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options _: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_: UIApplication, didDiscardSceneSessions _: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
