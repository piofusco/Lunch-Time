//
//  SceneDelegate.swift
//  LunchTime
//
//  Created by jarvis on 12/26/21.
//
//

import UIKit


class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let calendarViewModel = CalendarViewModel(startDate: Date())
        let scheduleListViewController = CalendarViewController(
                viewModel: calendarViewModel,
                mainQueue: LunchMainQueue()
        )
        let navigationController = UINavigationController(rootViewController: scheduleListViewController)

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navigationController
        self.window = window
        self.window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}
