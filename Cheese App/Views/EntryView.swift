//
//  ContentView.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/3/24.
//

import SwiftUI

struct EntryView: View {
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
        .ignoresSafeArea(.all)

    }
}


#Preview {
    EntryView()
}

