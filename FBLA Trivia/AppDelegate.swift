//
//  AppDelegate.swift
//  FBLA Trivia
//
//  Created by Tanner York on 1/15/19.
//  Copyright © 2019 Tanner York. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var orientationLock = UIInterfaceOrientationMask.portrait


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        let player = Auth.auth().currentUser?.displayName!
        print("\(player ?? "Error") entered background")
        
        if GameSession.shared.PlayerSession != nil {
            GameSession.shared.gameActivityChecker.remove()
            FirestoreData.shared.removePlayer(Auth.auth().currentUser!.displayName!, from: GameSession.shared.PlayerSession!) { (bool) in
                if bool == false {
                    print("Error deleting session after going to background.")
                } else {
                    GameSession.shared.PlayerSession = nil
                    print("\(player) was removed from the session.")
                    GameSession.shared.resetData()
                }
            }
        } else if GameSession.shared.AdminSession != nil {
            GameSession.shared.gameActivityChecker.remove()
            FirestoreData.shared.deleteSession(GameSession.shared.AdminSession!) { (bool) in
                if bool == true {
                    print("Session deleted")
                    GameSession.shared.resetData()
                } else {
                    print("Error, session not deleted.")
                }
            }
        }
        
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        let view = UIApplication.shared.topMostViewController()
        
        if (view?.canPerformSegue(withIdentifier: "unwindToOptionsVC"))! {
            view?.performSegue(withIdentifier: "unwindToOptionsVC", sender: view)
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        print("About to terminate app")
        
        if GameSession.shared.PlayerSession != nil {
            FirestoreData.shared.removePlayer((Auth.auth().currentUser?.displayName)!, from: GameSession.shared.PlayerSession!) { (bool) in
                GameSession.shared.PlayerSession = nil
            }
        } else if GameSession.shared.AdminSession != nil {
            FirestoreData.shared.deleteSession(GameSession.shared.AdminSession!) { (bool) in
                if bool == true {
                    print("Session: \(GameSession.shared.AdminSession!) deleted")
                } else {
                    
                }
            }
        }
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }


}

