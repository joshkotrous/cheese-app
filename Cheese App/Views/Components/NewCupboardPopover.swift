//
//  NewCupboardPopover.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/5/24.
//

import SwiftUI

struct NewCupboardPopover: View {
    @Binding var showCupboardPopover: Bool
    @State private var newCupboardInput: String = ""
    @AppStorage("profileId") var profileId: String?

    var body: some View {
        ZStack{
            CustomColors.background
                .ignoresSafeArea(.all)
            VStack {
                Text("Add Cupboard")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.custom("IowanOldStyle-Roman", size: 24))
                TextField("", text: $newCupboardInput, prompt: Text("Cupboard name").foregroundColor(CustomColors.textColor).font(.custom("IowanOldStyle-Roman", size: 18)))
                    .foregroundColor(CustomColors.textColor)
                    .font(.custom("IowanOldStyle-Roman", size: 18))
                Button(action: {
                    Task {
                        if (profileId != nil && (newCupboardInput != nil || newCupboardInput != "")) {
                             await Database().createNewCupboard(profileId: profileId!, cupboardName: newCupboardInput)
                            showCupboardPopover = false
                        }
                    }
             
            
                }) {
                    Text("Add")
                        .frame(maxWidth: .infinity)
                        .font(.custom("IowanOldStyle-Roman", size: 18))
                        .padding()
                }
                .background(CustomColors.tan1)
                .foregroundColor(CustomColors.textColor)
                .frame(maxWidth: .infinity)
                .cornerRadius(16)
                Spacer()

            }
            .foregroundColor(CustomColors.textColor)
            .padding()

        }
    }
}

#Preview {
    MyCheesesView()
}
