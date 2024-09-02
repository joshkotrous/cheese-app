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
                        
                        HStack{
                            ZStack{
                                AsyncImage(url: URL(string: profile?.image ?? "")) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    case .failure:
                                        Image(systemName: "photo")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(.gray)
                                    @unknown default:
                                        Image(systemName: "photo")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(.gray)
                                    }
                                }
                                .aspectRatio(contentMode: .fill)
                                .cornerRadius(24)
                            }.frame(width: 100, height: 100)
                                .background(CustomColors.button) // Set the background color
                                .cornerRadius(.infinity)
             
                            Spacer()
                            VStack{
                                Text("0")
                                Text("Cheeses")

                            }
                            .font(.custom(AppConfig.fontName, size: 16))

                            Divider()
                                .frame(width: 25)
                                .frame(height: 75)
                            VStack{
                                Text("0")
                                Text("Followers")
                            }
                            .font(.custom(AppConfig.fontName, size: 16))

                            Divider()
                                .frame(width: 25)
                                .frame(height: 75)
                            VStack{
                                Text("0")
                                Text("Following")
                            }
                            .font(.custom(AppConfig.fontName, size: 16))

                        }
                        Text(profile?.bio ?? "").frame(maxWidth: .infinity, alignment: .leading)
                            NavigationLink(destination: EditProfileView(username: $username, bio: $bio, profileId: $profileId, profileImageUrl: profile?.image)){
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
