//
//  SceneDelegate.swift
//  TaskInoxsoft
//
//  Created by Oлександр Хоменко on 18.02.2026.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var coordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let diContainer = AppDIContainer()

        let window = UIWindow(windowScene: windowScene)
        self.window = window

        coordinator = AppCoordinator(window: window, diContainer: diContainer)
        coordinator?.start()
    }
}
