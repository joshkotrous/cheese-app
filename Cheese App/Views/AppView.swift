//
//  AppView.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/4/24.
//

import SwiftUI

struct AppView: View {
    init() {
        UITabBar.appearance().backgroundColor = UIColor(CustomColors.background)

    }
    var body: some View {

        ZStack{
            CustomColors.background
                .edgesIgnoringSafeArea(.all)
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
        }
        .navigationBarBackButtonHidden(true)
    }

}

#Preview {
    AppView()
}
