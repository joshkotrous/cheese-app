//
//  SearchBar.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/4/24.
//

import SwiftUI

struct SearchBar: View {
    @State private var textInput: String = ""
    @State private var isFocused: Bool = false
    @FocusState private var textFieldIsFocused: Bool // Focus state for the TextField

    var body: some View {
        ZStack{
            Color.black
                    .opacity(isFocused ? 0.5 : 0.0) // Adjust opacity when focused
                    .edgesIgnoringSafeArea(.all)
                    .animation(.easeInOut(duration: 0.2), value: isFocused) // Smooth animation
            VStack{
                ZStack{
                    Color(CustomColors.tan1)
                        .edgesIgnoringSafeArea(.all)

                    HStack{
                        Image("BiSearchAlt2")
                            .resizable()
                            .frame(width: 25)
                            .frame(height: 25)

                        TextField("", text: $textInput, prompt: Text("Cheese name, type, or monger").foregroundColor(CustomColors.textColor).font(.custom(AppConfig.fontName, size: 18)))
                                .foregroundColor(CustomColors.textColor)
                                .font(.custom(AppConfig.fontName, size: 18))
                                .focused($textFieldIsFocused) // Bind focus state to TextField
                                .onChange(of: textFieldIsFocused) { newValue in
                                    isFocused = newValue // Update isFocused based on TextField focus state
                                }
                    }
                    .padding()
                    .background(.white)
                    .frame(width: 325)
                    .frame(height: 35)
                    .cornerRadius(100.0)
                }
                .offset(x: 0, y: 0)
                .frame(height: 75)
                Spacer()
            }
        }
    }
}

#Preview {
    HomeView()
}
