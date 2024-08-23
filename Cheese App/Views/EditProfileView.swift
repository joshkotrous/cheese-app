//
//  EditProfileView.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/22/24.
//

import SwiftUI

struct EditProfileView: View {
    @Binding var username: String
    @Binding var bio: String
    @Binding var profileId: String
    @State var showAlert: Bool = false
    var body: some View {

        ZStack{
            CustomColors.background
                .ignoresSafeArea(.all)
                VStack(spacing: 24){
                    Text("Edit Profile")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.custom("IowanOldStyle-Roman", size: 24))
                    VStack{
                        Text("Username")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        TextField("", text: $username, prompt: Text("Username").foregroundColor(CustomColors.textColor).font(.custom("IowanOldStyle-Roman", size: 18)))
                            .padding(8)
                            .foregroundColor(CustomColors.textColor)
                            .font(.custom("IowanOldStyle-Roman", size: 18))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(CustomColors.textColor, lineWidth: 1)
                            )
                            .ignoresSafeArea(.keyboard)

                    }
                    
                    VStack{
                        Text("Bio")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        TextField("", text: $bio, prompt: Text("Bio").foregroundColor(CustomColors.textColor).font(.custom("IowanOldStyle-Roman", size: 18)))
                            .padding(8)
                            .foregroundColor(CustomColors.textColor)
                            .font(.custom("IowanOldStyle-Roman", size: 18))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(CustomColors.textColor, lineWidth: 1)
                            )
                            .ignoresSafeArea(.keyboard)

                    }
                    
                    Button(action: {
                        Task {
                            await Database().updateProfile(profileId: profileId, bio: bio, username: username)
                        }
                    }) {
                        Text("Save Changes")
                            .padding()
                            .font(.custom("IowanOldStyle-Roman", size: 16))
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
                            .font(.custom("IowanOldStyle-Roman", size: 16))
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
                            .font(.custom("IowanOldStyle-Roman", size: 16))
                        
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
