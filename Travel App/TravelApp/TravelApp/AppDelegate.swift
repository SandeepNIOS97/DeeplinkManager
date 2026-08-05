//
//  AppDelegate.swift
//  TravelApp
//
//  Created by Sandeep Nigam on 05/08/26.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard let notificationURL = URL(string: "travelapp://country?countryName=France&screenType=countryDetail") else {
            return true
        }
        DeepLinkManager.shared.handleDeepLink(notificationURL)
        return true
    }
}
