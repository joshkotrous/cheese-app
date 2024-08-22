//
//  ProfileView.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/4/24.
//

import SwiftUI

struct ProfileView: View {
    @AppStorage("accessToken") var accessToken: String?
    @AppStorage("userId") var userId: String?
    @AppStorage("profileId") var profileId: String?
    @State var profile: Profile?
    
    var body: some View {
        ZStack{
            CustomColors.background
                .edgesIgnoringSafeArea(.all)
            VStack{
                Text("Profile")
                    .font(.custom("IowanOldStyle-Roman", size: 28))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if (accessToken != "" && accessToken != nil) {
                }
                
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
                Text(profile?.bio ?? "").frame(maxWidth: .infinity, alignment: .leading)
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
        .foregroundColor(CustomColors.textColor)
        .task {
            if (userId != nil){
                profile = await Database().getUserProfile(userId: userId!)
            }
        }
    }
}

#Preview {
    ProfileView()
}
