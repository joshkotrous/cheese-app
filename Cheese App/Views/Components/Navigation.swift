//
//  Navigation.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/4/24.
//

import SwiftUI

struct Navigation: View {
    var body: some View {
        ZStack{
            HStack {
                VStack{
                    Image("AiOutlineHome")
                    Text("Home")
                        .foregroundColor(CustomColors.textColor)
                        .frame(maxWidth: .infinity)
                }
                VStack{
                    Image("PiCheeseLight")
                    Text("My Cheeses")
                        .foregroundColor(CustomColors.textColor)
                        .frame(maxWidth: .infinity)
                }

                VStack{
                    Image("AiOutlineCompass")
                    Text("Discover")
                        .foregroundColor(CustomColors.textColor)
                        .frame(maxWidth: .infinity)
                }

                VStack{
                    Image("BiSearchAlt2")
                    Text("Search")
                        .foregroundColor(CustomColors.textColor)
                        .frame(maxWidth: .infinity)
                }

                VStack{
                    Image("AiOutlineUser")
                    Text("My Profile")
                        .foregroundColor(CustomColors.textColor)
                        .frame(maxWidth: .infinity)
                }



            }
            .font(.custom("IowanOldStyle-Roman",size: 12))
            
        }
        .frame(height: 100)
        .frame(maxWidth: .infinity)
        .overlay(
            Rectangle()
                .frame(height: 1) // Height of the border
                .foregroundColor(CustomColors.textColor), // Color of the border
            alignment: .top
        )
    
    }
}

#Preview {
    Navigation()
}
