//
//  AppDelegate.swift
//  EveryBodySquat
//
//  Created by Eddie A Tejeda on 2/23/19.
//  Copyright © 2019 Visudo. All rights reserved.
//

import UIKit
import WebKit
import Turbolinks


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationController =  UINavigationController()
    lazy var session: Session = {
        let configuration = WKWebViewConfiguration()
        configuration.applicationNameForUserAgent = "EveryBodySquat iOS"
        return Session( webViewConfiguration: configuration )
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        navigationController.setNavigationBarHidden(true, animated: true)
        window?.rootViewController = navigationController
        session.delegate = self
        
        #if targetEnvironment(simulator)
        visit(URL: URL(string: "http://localhost:3000")!)
        #else
        visit(URL: URL(string: "https://www.everybodysquat.com")!)
        #endif
        return true
    }

    func visit(URL: URL){
        let viewController = VisitableViewController(url: URL)
        navigationController.pushViewController(viewController, animated: false)
        session.visit(viewController)
    }

}


extension AppDelegate: SessionDelegate {
    func session(_ session: Session, didFailRequestForVisitable visitable: Visitable, withError error: NSError) {
        //
    }
    
    func session(_ session: Session, didProposeVisitToURL URL: URL, withAction action: Action) {
        visit(URL: URL)
    }
    

}
