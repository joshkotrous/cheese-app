//
//  DiscoverView.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/4/24.
//

import SwiftUI

struct DiscoverView: View {
    var body: some View {
        ZStack{
            
            
            VStack(spacing: 0){
//                Spacer(minLength: 75)
                ZStack{
                    CustomColors.background
                        .edgesIgnoringSafeArea(.all)
                    VStack{
                        Text("Feed")
                            .font(.custom(AppConfig.fontName, size: 28))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding()
                }
                .foregroundColor(CustomColors.textColor)
            }
//            VStack{
//                SearchBar()
//
//            }
        }
    }
}

#Preview {
    DiscoverView()
}
