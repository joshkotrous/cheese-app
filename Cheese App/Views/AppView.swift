//
//  AppView.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/4/24.
//

import SwiftUI

struct AppView: View {

    init() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor(CustomColors.background)
        ]
        navigationBarAppearance.backgroundColor = UIColor(CustomColors.background)
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(CustomColors.background)
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor(CustomColors.textColor)
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(CustomColors.textColor)]
    tabBarAppearance.stackedItemSpacing = 20.0
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        UITabBar.appearance().standardAppearance = tabBarAppearance

    }
    var body: some View {
                TabView{
                    HomeView()
                        .tabItem {
                            Image("AiOutlineHome")
                                Text("Home")
                        }
                    MyCheesesView()
                        .tabItem {
                            Image("PiCheeseLight")
                            Text("My Cheeses")
                        }
                    DiscoverView()
                        .tabItem {
                            Image("AiOutlineCompass")
                            Text("Discover")
                        }
                    SearchView()
                        .tabItem {
                            Image("BiSearchAlt2")
                            Text("Search")
                        }
                    ProfileView()
                        .tabItem {
                            Image("AiOutlineUser")
                            Text("Profile")
                        }
                }
                .tint(Color(CustomColors.tan2))
                .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    AppView()
}
