//
//  AppDelegate.swift
//  Calculadora
//
//  Created by carlos paredes on 10/08/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
      
        
        //setup
        setupView()
        
        return true
    }
    // Private Methods
    
    private func setupView(){
        
        window = UIWindow(frame: UIScreen.main.bounds)  //toda la pantalla del iphone
        let vc = HomeViewController()   //intanciando un controlador
        window?.rootViewController = vc
        window?.makeKeyAndVisible()    //que se inicio y se muestre visible
    }


}

