//
//  WelcomeView.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/4/24.
//

import SwiftUI

struct WelcomeView: View {
    @Binding var showLoginScreen: Bool
    @State private var opacity: Double = 1.0

    var body: some View {
        ZStack {
            // Background color
            CustomColors.background
                .edgesIgnoringSafeArea(.all) // Extend the color to the edges of the screen
            Image("cheeses")
                .resizable()
                .aspectRatio(contentMode: .fill) // Adjust the aspect ratio
                .clipped() // Ensure the image fits within the frame

            // Foreground content
            VStack {
                Text("Cheese \n App")
                    .font(.custom("IowanOldStyle-Roman", size: 48))
                    .fontWeight(.bold)
                    .foregroundColor(CustomColors.textColor)
                    .multilineTextAlignment(.center)
            }
            .padding()
        }
        .opacity(opacity)
        .onAppear {
            // Set a timer to transition to the main screen after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                showLoginScreen = true
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    @State static var showLoginScreen = false

    static var previews: some View {
        WelcomeView(showLoginScreen: $showLoginScreen)
    }
}
