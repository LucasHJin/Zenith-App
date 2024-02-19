//
//  ZenithAppApp.swift
//  ZenithApp
//
//  Created by Lucas Jin on 2024-02-16.
//

import FirebaseCore
import SwiftUI
import Firebase

@main
struct ZenithAppApp: App {
    init() {
        FirebaseApp.configure() //configure app with package dependencies
    }
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
