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
        VStack{
            ZStack{
                Color(CustomColors.tan1)
                    .edgesIgnoringSafeArea(.all)
                HStack{
                    Image("BiSearchAlt2")
                        .resizable()
                        .frame(width: 25)
                        .frame(height: 25)
                        .ignoresSafeArea(.keyboard)
                    TextField("", text: $textInput, prompt: Text("Cheese name, type, or monger").foregroundColor(CustomColors.textColor).font(.custom("IowanOldStyle-Roman", size: 18)))
                        .foregroundColor(CustomColors.textColor)
                        .font(.custom("IowanOldStyle-Roman", size: 18))
                        .ignoresSafeArea(.keyboard)

                }
                .ignoresSafeArea(.keyboard)
                .padding()
                .background(.white)
                .frame(width: 325)
                .frame(height: 35)
                .cornerRadius(100.0)
            }
            .offset(x: 0, y: 0)
            .frame(height: 75)
            .ignoresSafeArea(.keyboard)
        }
        .ignoresSafeArea(.keyboard)
        .frame(maxHeight: .infinity)
        
    }

}

#Preview {
    HomeView()
}
