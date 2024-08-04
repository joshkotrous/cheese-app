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
                VStack{
                    Text("Test")
                }
                .frame(height: .infinity)
                Spacer()
                Navigation()
            }
       
            
        }
            .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    AppView()
}
