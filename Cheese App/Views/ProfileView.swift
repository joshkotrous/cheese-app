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
    @State var profileId: String = ""
    @State var bio: String = ""
    @State var username: String = ""
    @State var profile: Profile?
    
    var body: some View {
        NavigationStack{
            
            
            ZStack{
                CustomColors.background
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    Text(username)
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
                    NavigationLink(destination: EditProfileView(username: $username, bio: $bio, profileId: $profileId)){
                        Text("Edit Profile")
                            .padding()
                            .font(.custom("IowanOldStyle-Roman", size: 16))
                            .frame(maxWidth: .infinity)
                            .background(CustomColors.tan1)
                    }
                    .cornerRadius(16)
                    Spacer()
                }
                .padding()
            }
            .foregroundColor(CustomColors.textColor)
            .task {
                if (userId != nil){
                    profile = await Database().getUserProfile(userId: userId!)
                    username = profile?.username ?? ""
                    profileId = profile?.id ?? ""
                    bio = profile?.bio ?? ""
                }
            }
        }
        .tint(Color(CustomColors.tan2))
        .ignoresSafeArea(.keyboard)

    }
}

#Preview {
    ProfileView()
}
