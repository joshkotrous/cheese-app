//
//  AppView.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/4/24.
//

import SwiftUI

enum Tab {
    case home
    case profile
    case mycheeses
    case discover
    case search
    
}

struct AppView: View {
    @State private var selectedTab: Tab = .home
    
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
        TabView(selection: $selectedTab){
            HomeView()
                .tabItem {
                    if (selectedTab == Tab.home){
                        Image("AiOutlineHomeDark")

                    } else {
                        Image("AiOutlineHome")

                    }
                    Text("Home")
                }
                .tag(Tab.home)
            
            
            MyCheesesView(selectedTab: $selectedTab)
                .tabItem {
                    if(selectedTab == Tab.mycheeses){
                        Image("PiCheeseLightDark")

                    } else {
                        Image("PiCheeseLight")

                    }
                    Text("My Cheeses")
                }
                .tag(Tab.mycheeses)
                        
            DiscoverView()
                .tabItem {
                    if (selectedTab == Tab.discover){
                        Image("AiOutlineCompassDark")

                    } else {
                        Image("AiOutlineCompass")

                    }
                    Text("Discover")
                }
                .tag(Tab.discover)
            
            SearchView()
                .tabItem {
                    if (selectedTab == Tab.search) {
                        Image("BiSearchAlt2Dark")

                    } else {
                        Image("BiSearchAlt2")

                    }
                    Text("Search")
                }
                .tag(Tab.search)
            
            ProfileView()
                .tabItem {
                    if (selectedTab == Tab.profile){
                        Image("AiOutlineUserDark")

                    } else {
                        Image("AiOutlineUser")

                    }
                    Text("Profile")
                }
                .tag(Tab.profile)            
        }
        .tint(Color(CustomColors.tan2))
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    AppView()
}
