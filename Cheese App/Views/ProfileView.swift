//
//  ProfileView.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/4/24.
//

import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var isLoading: Bool = true
}

struct ProfileView: View {
    @AppStorage("accessToken") var accessToken: String?
    @AppStorage("userId") var userId: String?
    @State var profileId: String = ""
    @State var bio: String = ""
    @State var profileImageUrl: String?

    @State var username: String = ""
    @State var profile: Profile?
    @StateObject var viewModel = ProfileViewModel()
    
    var body: some View {
        NavigationStack{
            
            
            ZStack{
                CustomColors.background
                    .edgesIgnoringSafeArea(.all)
            
                    VStack{
                        if(viewModel.isLoading){
                            VStack{
                                ProgressView() // Spinner shown when loading
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .scaleEffect(1.5) // Make the spinner larger if needed
                            }.frame(maxWidth: .infinity, maxHeight: .infinity).background(CustomColors.background)
                        } else {
                        Text(username)
                            .font(.custom(AppConfig.fontName, size: 28))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if (accessToken != "" && accessToken != nil) {
                        }
                        
                            HStack(spacing: 0){
                            ZStack{
                                if profileImageUrl != nil && profileImageUrl != "" {
                                    AsyncImage(url: URL(string: profileImageUrl ?? "")) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                        case .failure:
                                            Color.clear

                     
                                        @unknown default:
                                            Color.clear

//                                            Image(systemName: "camera")
//                                                .resizable()
//                                                .aspectRatio(contentMode: .fit)
//                                                .frame(width: 28)
//                                                .foregroundColor(CustomColors.textColor)
                                        }
                                    }
                                    .id(UUID())
                                    .aspectRatio(contentMode: .fill)
                                    .cornerRadius(24)
                                } else {
                                    Image(systemName: "camera")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 28)
                                        .foregroundColor(CustomColors.textColor)
                                }
                
                            }.frame(width: 100, height: 100)
                                .background(CustomColors.button) // Set the background color
                                .cornerRadius(.infinity)
             
                            Spacer()
                            VStack{
                                Text("0")
                                Text("Cheeses")
                                    .lineLimit(1)

                            }
                            .font(.custom(AppConfig.fontName, size: 16))
                            
                            Divider()
                                .frame(width: 25)
                                .frame(height: 75)
                            VStack{
                                Text("0")
                                Text("Followers")
                                    .lineLimit(1)

                            }
                            .font(.custom(AppConfig.fontName, size: 16))

                            Divider()
                                .frame(width: 25)
                                .frame(height: 75)
                            VStack{
                                Text("0")
                                Text("Following")
                                    .lineLimit(1)

                            }
                            .font(.custom(AppConfig.fontName, size: 16))

                        }
                        Text(profile?.bio ?? "").frame(maxWidth: .infinity, alignment: .leading)
                            NavigationLink(destination: EditProfileView(username: $username, bio: $bio, profileId: $profileId, profileImageUrl: $profileImageUrl, profile: $profile)){
                            Text("Edit Profile")
                                .padding()
                                .font(.custom(AppConfig.fontName, size: 16))
                                .frame(maxWidth: .infinity)
                                .background(CustomColors.tan1)
                        }
                        .cornerRadius(16)
                        Spacer()
                    }
            
                }
                    .padding()
                    .foregroundColor(CustomColors.textColor)
                    .task {
                        if (userId != nil){
                            profile = await Database().getUserProfile(userId: userId!)
                            username = profile?.username ?? ""
                            profileId = profile?.id ?? ""
                            bio = profile?.bio ?? ""
                            profileImageUrl = profile?.image ?? ""
                        }
                        viewModel.isLoading = false

                    }
            }
            .tint(Color(CustomColors.tan2))
            .ignoresSafeArea(.keyboard)
        }
    }
}

#Preview {
    ProfileView()
}
