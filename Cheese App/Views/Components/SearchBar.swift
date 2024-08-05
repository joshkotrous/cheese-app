//
//  SearchBar.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/4/24.
//

import SwiftUI

struct SearchBar: View {
    @State private var textInput: String = ""

    var body: some View {
        ZStack{
            Color(hex: "#FAEBC6")
                .edgesIgnoringSafeArea(.all)

            HStack{
                Image("BiSearchAlt2")
                    .resizable()
                    .frame(width: 25)
                    .frame(height: 25)
                TextField("Cheese name, type, or monger", text: $textInput)
                    .foregroundColor(CustomColors.textColor)
            }
            .padding()
            .background(.white)
            .frame(width: 325)
            .frame(height: 35)
            .cornerRadius(100.0)
        }
        .frame(height: 100)
    }
}

#Preview {
    HomeView()
}
