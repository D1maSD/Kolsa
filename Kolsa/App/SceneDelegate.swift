//
//  SceneDelegate.swift
//  Kolsa
//
//  Created by Dima Melnik on 7/4/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: ApplicationCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        self.window = window
        let appCoordinator = ApplicationCoordinator(window: window)
        self.appCoordinator = appCoordinator
        appCoordinator.start()
    } 
}
