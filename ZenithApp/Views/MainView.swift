//
//  ContentView.swift
//  Zenith
//
//  Created by Lucas Jin on 2024-01-23.
//

import SwiftUI

struct MainView: View {
    @StateObject var MainViewVM = MainViewViewModel()
    
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor.white
    }
    
    
   var body: some View {
       if MainViewVM.isSignedIn, !MainViewVM.currentUserID.isEmpty { //if signed in and the currentUserID is actually assigned to something
           //actual app view
           accountView
           
       } else {
           LoginView()
       }
   }
    
    var accountView: some View { //computed property rather than a function
        //https://www.swiftyplace.com/blog/tabview-in-swiftui-styling-navigation-and-more#:~:text=SwiftUI%20TabView%20is%20a%20main,bar%20items%20at%20the%20bottom.
        TabView {
            ProfileView()
                .tabItem{
                    Label("Profile", systemImage: "person.circle")
                }
            TrackerView()
                .tabItem{
                    Label("Tracker", systemImage: "dumbbell.fill")
                }
            WalkthroughView()
                .tabItem{
                    Label("Exercise Tutorials", systemImage: "lightbulb.circle.fill")
                }
        }
    }
}

#Preview {
    MainView()
}
