//
//  MoodMeApp.swift
//  MoodMe
//
//  Created by Shayet on 1/12/24.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct MoodMeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var videoViewModel = VideoViewModel()
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ScreenView()
                    .environmentObject(videoViewModel)
            }
        }
    }
}
