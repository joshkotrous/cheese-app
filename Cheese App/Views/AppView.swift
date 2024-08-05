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
        
        // MARK: Tab bar appearance
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(CustomColors.background)
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
                .tint(Color(hex: "#6C5B30"))
                .frame(width: .infinity)
                .frame(height: .infinity)
                .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    AppView()
}
