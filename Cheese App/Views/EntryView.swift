//
//  ContentView.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/3/24.
//

import SwiftUI

struct EntryView: View {
    @State private var showLoginScreen = false
    @AppStorage("accessToken") var accessToken: String?
    var body: some View {
        Group {
            ZStack {
                if (accessToken == nil){
                    LoginView()

                } else {
                    AppView()
                }
                WelcomeView()

            }
       
        }
    }
}


#Preview {
    EntryView()
}

