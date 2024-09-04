//
//  EditProfileView.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/22/24.
//

import SwiftUI

class EditProfileViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var opacity: Double = 1.0
}

struct EditProfileView: View {
    @Binding var username: String
    @Binding var bio: String
    @Binding var profileId: String
    @State var showAlert: Bool = false
    @StateObject var viewModel = EditProfileViewModel()
    @State var updatedSuccessfully: Bool = false
    @State var image: UIImage?
    @State private var showActionSheet = false
    @State var showImagePicker: Bool = false
    @Binding var profileImageUrl: String?
    @AppStorage("userId") var userId: String?
    @Binding var profile: Profile?
    let client = Database.shared

    var body: some View {
        var imagePickerSourceType: UIImagePickerController.SourceType = .camera

            ZStack{
                CustomColors.background
                    .ignoresSafeArea(.all)
                if(viewModel.isLoading){
                    VStack{
                        ProgressView() // Spinner shown when loading
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.5) // Make the spinner larger if needed
                    }.frame(maxWidth: .infinity, maxHeight: .infinity).zIndex(100)
                }
                
                if (updatedSuccessfully) {
                    HStack{
                        Text("Profile Updated Successfully")
                            .foregroundColor(.black)
                        Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                    }
                    .zIndex(100)
                    .opacity(viewModel.opacity)
                    .onAppear {
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            
                            withAnimation(.easeInOut(duration: 1)) {
                                viewModel.opacity = 0.0
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                updatedSuccessfully = false
                            }
                        }
                    }.onDisappear {
                        viewModel.opacity = 1.0
                    }
                }
                ScrollView {
                
                VStack(spacing: 16){
                    Text("Edit Profile")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.custom(AppConfig.fontName, size: 24))
                        .fontWeight(.bold)
                    
                    
                    ZStack{
                        if let image = image {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } else if profileImageUrl != nil && profileImageUrl != "" {
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

//                                    Image(systemName: "camera")
//                                        .resizable()
//                                        .aspectRatio(contentMode: .fit)
//                                        .frame(width: 28)
//                                        .foregroundColor(CustomColors.textColor)
                                }
                            }
                            .aspectRatio(contentMode: .fill)
                            .cornerRadius(24)
                        }
                        Menu {
                            Button(action: {
                                imagePickerSourceType = .camera
                                showImagePicker = true
                            }) {
                                Label("Take Photo", systemImage: "camera")
                            }
                            
                            Button(action: {
                                imagePickerSourceType = .photoLibrary
                                showImagePicker = true
                            }) {
                                Label("Photo Library", systemImage: "photo.on.rectangle")
                            }
                            if (profileImageUrl != nil && profileImageUrl != "") || image != nil {
                                Button(role: .destructive, action: {
                                    if image != nil {
                                        image = nil
                                    }
                                 
                                    Task {
                                        if (profileImageUrl != nil && profileImageUrl != "") && image == nil {
                                            await client.deleteProfilePhoto(userId: userId!)
                                            profile?.image = ""
                                            await client.updateProfile(profile: profile!)

                                        }

                                    }
                                }) {
                                    Label("Remove Image", systemImage: "xmark")
                                }
                            }
             
                        } label: {
                            if image != nil || (profileImageUrl != nil && profileImageUrl != "") {
                                Label("Edit Photo", systemImage: "camera")
                                    .padding()
                                    .foregroundColor(CustomColors.textColor)
                                    .background(CustomColors.button)
                                    .cornerRadius(18)
                            } else {
                                Label("Add Photo", systemImage: "camera")
                                    .padding()
                                    .foregroundColor(CustomColors.textColor)
                            }
                            
                        }
                        .sheet(isPresented: $showImagePicker) {
                            ZStack{
                                Color.black.edgesIgnoringSafeArea(.all)
                                ImagePicker(image: $image, sourceType: imagePickerSourceType)

                            }
                                
                            
                        }
                    }.frame(width: 150, height: 150)
                        .background(CustomColors.button) // Set the background color
                        .cornerRadius(.infinity)
                        .padding()
                    
                    VStack{
                        Text("Username")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.custom(AppConfig.fontName, size: 16))
                        
                        TextField("", text: $username, prompt: Text("Username").foregroundColor(CustomColors.textColor).font(.custom(AppConfig.fontName, size: 18)))
                            .foregroundColor(CustomColors.textColor)
                            .padding(8)
                            .font(.custom(AppConfig.fontName, size: 18))
                            .background(RoundedRectangle(cornerRadius: 12).fill(CustomColors.tan1))
                        
                    }
                    
                    VStack{
                        Text("Bio")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.custom(AppConfig.fontName, size: 16))
                        TextField("", text: $bio, prompt: Text("Bio").foregroundColor(CustomColors.textColor).font(.custom(AppConfig.fontName, size: 18)))
                            .foregroundColor(CustomColors.textColor)
                            .padding(8)
                            .font(.custom(AppConfig.fontName, size: 18))
                            .background(RoundedRectangle(cornerRadius: 12).fill(CustomColors.tan1))
                        
                    }
                    
                    Button(action: {
                        Task {
                            viewModel.isLoading = true
                            if profile != nil {
                                profile?.bio = bio
                                profile?.username = username
                                await client.updateProfile(profile: profile!)
                            }
                            if image != nil {
                                profileImageUrl = await client.uploadProfileImage(image: image!, userId: userId!)
                            }
                            viewModel.isLoading = false
                            updatedSuccessfully = true
                            
                        }
                    }) {
                        Text("Save Changes")
                            .padding()
                            .font(.custom(AppConfig.fontName, size: 16))
                            .frame(maxWidth: .infinity)
                            .background(CustomColors.tan1)
                        
                        
                    }
                    .cornerRadius(16)
                    
                    Spacer(minLength: 278)
                    Button(action: {
                        Task {
                            await client.signOut()
                        }
                    }){
                        Text("Sign Out")
                            .padding()
                            .font(.custom(AppConfig.fontName, size: 16))
                            .frame(maxWidth: .infinity)
                            .background(CustomColors.tan1)
                        
                        
                    }
                    .cornerRadius(16)
                    
                    
                    Button(role: .destructive, action: {
                        showAlert = true
                        print("Delete button tapped")
                    }) {
                        Text("Delete Account")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red.opacity(0.5))
                            .foregroundColor(Color.red)
                            .cornerRadius(16)
                            .font(.custom(AppConfig.fontName, size: 16))
                        
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Delete Account"),
                            message: Text("Are you sure you want to delete your account?"),
                            primaryButton: .destructive(Text("Delete")) {
                                Task{
                                    await client.deleteUser()
                                }
                                print("Account deleted")
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
                .foregroundColor(CustomColors.textColor)
                .padding()
                .frame(maxHeight: .infinity)
                .ignoresSafeArea(.keyboard)
                
            }
            .frame(maxHeight: .infinity)
            .ignoresSafeArea(.keyboard)
            
            
        }      .frame(maxHeight: .infinity)
            .ignoresSafeArea(.keyboard)

    }
    
}

struct EditProfileViewPreviewWrapper: View {
    @State private var username: String = "test"
    @State private var bio: String = "testbio"
    @State private var profileId: String = "testprofileId"
    @State private var profileImageUrl: String?
    @State private var profile: Profile? = Profile()
    var body: some View {
        EditProfileView(username: $username, bio: $bio, profileId: $profileId, profileImageUrl: $profileImageUrl, profile: $profile)
    }
}

#Preview {
    EditProfileViewPreviewWrapper()
}
