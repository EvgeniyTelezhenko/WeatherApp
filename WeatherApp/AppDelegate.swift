//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Евгений Тележенко on 08.06.2021.



import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let appCoordinator = AppCoordinator()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        buildModule()
        return true
    }
    func buildModule(){
        appCoordinator.createModule()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = appCoordinator.controllers.first
        window?.makeKeyAndVisible()
    }
    
}

