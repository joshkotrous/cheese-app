//
//  ContentView.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/3/24.
//

import SwiftUI

struct EntryView: View {
    @State private var showLoginScreen = false

    var body: some View {
        Group {
            ZStack {
                LoginView()
                WelcomeView()

            }
       
        }
    }
}


#Preview {
    EntryView()
}

