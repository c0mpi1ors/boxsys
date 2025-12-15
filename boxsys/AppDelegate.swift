//
//  AppDelegate.swift
//  boxsys
//
//  Migrated to Swift from Objective-C
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        JuBoxSys2.initBoxSys(versionNumber: 100)

        if let dmodel = AppDelegate.getDictionary(fromFile: "JuModel") {
            JuBoxSys2.loadModel(dmodel)
        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate.
    }

    // MARK: - Helper Methods

    static func getDictionary(fromFile name: String) -> [String: Any]? {
        guard let path = Bundle.main.path(forResource: name, ofType: "json") else {
            return nil
        }

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            return json as? [String: Any]
        } catch {
            print("Error loading JSON file: \(error)")
            return nil
        }
    }
}
