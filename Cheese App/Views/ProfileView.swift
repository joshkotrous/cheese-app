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
                    .font(.custom("IowanOldStyle-Roman", size: 36))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
            }
            .padding()
        }
        .foregroundColor(CustomColors.textColor)  }
}

#Preview {
    ProfileView()
}
