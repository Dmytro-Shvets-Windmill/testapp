//
//  SceneDelegate.swift
//  Runner
//
//  Created by Dima Shvets on 17.02.2022.
//

import UIKit
import Flutter

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = scene as? UIWindowScene else { return }

        window = UIWindow(windowScene: windowScene)
        let flutterEngine = FlutterEngine(name: "SceneDelegateEngine")
        flutterEngine.run()
        GeneratedPluginRegistrant.register(with: flutterEngine)
        let controller = FlutterViewController.init(engine: flutterEngine, nibName: nil, bundle: nil)
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        guard let blurView = window?.viewWithTag(Int(1)) else { return }
        UIView.animate(withDuration: 0.5, animations: {
            blurView.alpha = 0
        }, completion: { _ in
            blurView.removeFromSuperview()
        })
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.frame = window?.frame ?? .zero
        blurView.tag = Int(1)
        window?.addSubview(blurView)
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        print(url)
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        print(userActivity)
    }
    
}

