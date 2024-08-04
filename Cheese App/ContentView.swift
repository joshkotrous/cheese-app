//
//  ContentView.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/3/24.
//

import SwiftUI

struct ContentView: View {
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
                    .font(.custom("IowanOldStyle-Roman", size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(CustomColors.textColor)
                    .multilineTextAlignment(.center)
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}

