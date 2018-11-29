//
//  AppDelegate.swift
//  GAWeather
//
//  Created by Marco Guerrieri on 28/11/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var mainVC : GAWMainVC?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let mainSB = UIStoryboard.init(name: "Main", bundle: nil)
        mainVC = mainSB.instantiateInitialViewController() as? GAWMainVC
        mainVC?.viewModel = GAWMainViewModel
            .init(apiHandler: GAWWeatherApiHandler.init(environment: Environments.testEnv),
                  speechRecognizer: GAWSpeechRecognizer(),
                  commandParser: GAWCommandParser())
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = mainVC
        window!.makeKeyAndVisible()
        return true
    }
}

