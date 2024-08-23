//
//  EditProfileView.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/22/24.
//

import SwiftUI

class EditProfileViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var updatedSuccessfully: Bool = false
    @Published var opacity: Double = 1.0
}

struct EditProfileView: View {
    @Binding var username: String
    @Binding var bio: String
    @Binding var profileId: String
    @State var showAlert: Bool = false
    @StateObject var viewModel = EditProfileViewModel()
    
    
    var body: some View {

        ZStack{
            CustomColors.background
                .ignoresSafeArea(.all)
                if(viewModel.isLoading){
                    VStack{
                        ProgressView() // Spinner shown when loading
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.5) // Make the spinner larger if needed
                    }.frame(maxWidth: .infinity, maxHeight: .infinity).background(CustomColors.background)
                }
            
            if (viewModel.updatedSuccessfully) {
                HStack{
                    Text("Profile Updated Successfully")
                    Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                }
                .opacity(viewModel.opacity)
                .onAppear {
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        
                        withAnimation(.easeInOut(duration: 1)) {
                            viewModel.opacity = 0.0
                        }
                    }
                }
            }
               
            
                VStack(spacing: 16){
                    Text("Edit Profile")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.custom(AppConfig.fontName, size: 24))
                        .fontWeight(.bold)
                    VStack{
                        Text("Username")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.custom(AppConfig.fontName, size: 16))

                        TextField("", text: $username, prompt: Text("Username").foregroundColor(CustomColors.textColor).font(.custom(AppConfig.fontName, size: 18)))
                            .padding(8)
                            .foregroundColor(CustomColors.textColor)
                            .font(.custom(AppConfig.fontName, size: 18))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(CustomColors.textColor, lineWidth: 1)
                            )
                            .ignoresSafeArea(.keyboard)

                    }
                    
                    VStack{
                        Text("Bio")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.custom(AppConfig.fontName, size: 16))
                        TextField("", text: $bio, prompt: Text("Bio").foregroundColor(CustomColors.textColor).font(.custom(AppConfig.fontName, size: 18)))
                            .padding(8)
                            .foregroundColor(CustomColors.textColor)
                            .font(.custom(AppConfig.fontName, size: 18))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(CustomColors.textColor, lineWidth: 1)
                            )
                            .ignoresSafeArea(.keyboard)

                    }
                    
                    Button(action: {
                        Task {
                            viewModel.isLoading = true
                            await Database().updateProfile(profileId: profileId, bio: bio, username: username)
                            viewModel.isLoading = false
                            viewModel.updatedSuccessfully = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                viewModel.updatedSuccessfully = false
                            }
                            
                        }
                    }) {
                        Text("Save Changes")
                            .padding()
                            .font(.custom(AppConfig.fontName, size: 16))
                            .frame(maxWidth: .infinity)
                            .background(CustomColors.tan1)


                    }
                    .cornerRadius(16)
                    
                    Spacer()
                    Button(action: {
                        Task {
                            await Database().signOut()
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
                                    await Database().deleteUser()
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
        
            
        }
    
}

struct EditProfileViewPreviewWrapper: View {
    @State private var username: String = "test"
    @State private var bio: String = "testbio"
    @State private var profileId: String = "testprofileId"

    var body: some View {
        EditProfileView(username: $username, bio: $bio, profileId: $profileId)
    }
}

#Preview {
    EditProfileViewPreviewWrapper()
}
