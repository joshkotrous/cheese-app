//
//  ContentView.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/3/24.
//

import SwiftUI

struct ContentView: View {
    @State private var showLoginScreen = false

    var body: some View {
        Group {
            if showLoginScreen {
                LoginView()
            } else {
                WelcomeView(showLoginScreen: $showLoginScreen)
            }
        }
    }
}

#Preview {
    ContentView()
}

