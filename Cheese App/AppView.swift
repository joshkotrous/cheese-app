//
//  AppView.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/4/24.
//

import SwiftUI

struct AppView: View {
    var body: some View {
        ZStack{
            CustomColors.background
                .edgesIgnoringSafeArea(.all)
            VStack{
                Text("Hello, World!")
                ZStack{
                    Color.white
                        .edgesIgnoringSafeArea(.all)
                    VStack{
                        Text("Hello, World!")
                    }
                }
                .frame(height: 100)
            }
       
            
        }
            .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    AppView()
}
