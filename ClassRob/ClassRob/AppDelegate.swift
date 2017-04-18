//
//  AppDelegate.swift
//  ClassRob
//
//  Created by lcdtyph on 3/15/17.
//  Copyright © 2017 lcdtyph. All rights reserved.
//

import UIKit
import FMDB

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        guard let documents = try? FileManager.default.url(for: .documentDirectory,
                                                      in: .userDomainMask,
                                                      appropriateFor: nil,
                                                      create: true) else {
            fatalError("url error")
        }
        let favURL = documents.appendingPathComponent("fav.db")
        if FileManager.default.fileExists(atPath: favURL.path) {
            print("found fav.db: \(favURL.path)")
        } else {
            let database = FMDatabase(path: favURL.path)!
            if !database.open() {
                print("cannot open database")
            }
            do {
                try database.executeUpdate("create table favorite(" +
                                            "Cnumber char(8) not null, " +
                                            "Cname varchar(255) not null, " +
                                            "Cteacher char(16) not null, " +
                                            "Cday tinyint not null, " +
                                            "Cteacher char(16) not null, " +
                                            "Ctime_start tinyint not null, " +
                                            "Ctime_end tinyint not null, " +
                                            "Croom varchar(64) not null, " +
                                            "Cweeks varchar(64) not null" +
                                           ")", values: nil)
                database.close()
                print("fav.db created")
            }catch {
                print(error.localizedDescription)
            }
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

