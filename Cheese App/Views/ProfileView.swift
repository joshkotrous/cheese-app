//
//  ProfileView.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/4/24.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        ZStack{
            CustomColors.background
                .edgesIgnoringSafeArea(.all)
            VStack{
                Text("Profile")
                    .font(.custom("IowanOldStyle-Roman", size: 28))
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack{
                    Image("AiOutlineUser")
                    Spacer()
                    VStack{
                        Text("0")
                        Text("Cheeses")
                    }
                    Divider()
                        .frame(width: 25)
                        .frame(height: 75)
                    VStack{
                        Text("0")
                        Text("Followers")
                    }
                    Divider()
                        .frame(width: 25)
                        .frame(height: 75)
                    VStack{
                        Text("0")
                        Text("Following")
                    }
                }
                Button(action: {}){
                    Text("Edit Profile")
                        .padding()
                        .font(.custom("IowanOldStyle-Roman", size: 16))
                }
                .frame(maxWidth: .infinity)
                .background(CustomColors.tan1)
                .cornerRadius(16)
                Spacer()
            }
            .padding()
        }
        .foregroundColor(CustomColors.textColor)  }
}

#Preview {
    ProfileView()
}
