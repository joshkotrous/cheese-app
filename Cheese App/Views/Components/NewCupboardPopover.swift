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
    @Binding var cupboards: [Cupboard]?
    var body: some View {
        ZStack{
            CustomColors.background
                .ignoresSafeArea(.all)
            VStack {
                Text("Add Cupboard")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.custom(AppConfig.fontName, size: 24))
                    .fontWeight(.bold)
                TextField("", text: $newCupboardInput, prompt: Text("Cupboard name").foregroundColor(CustomColors.textColor).font(.custom(AppConfig.fontName, size: 18)))
                    .padding(4)
                    .foregroundColor(CustomColors.textColor)
                    .font(.custom(AppConfig.fontName, size: 18))
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(CustomColors.textColor, lineWidth: 1)
                        
                    }
                Button(action: {
                    Task {
                        if (profileId != nil && newCupboardInput != "") {
                            await Database().createNewCupboard(profileId: profileId ?? "", cupboardName: newCupboardInput)
                            showCupboardPopover = false
                        }
                        cupboards = await Database().getUserCupboards(profileId: profileId ?? "")
                    }
                    
                    
                }) {
                    Text("Add")
                        .frame(maxWidth: .infinity)
                        .font(.custom(AppConfig.fontName, size: 18))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(CustomColors.tan1)

                    
                }
                .foregroundColor(CustomColors.textColor)
                .cornerRadius(16)
                Spacer()
                
            }
            .foregroundColor(CustomColors.textColor)
            .padding()
            
        }
    }
}

struct NewCupboardPopoverPreview: View {
    @State var selectedTab: Tab = Tab.mycheeses
    var body: some View{
        MyCheesesView(selectedTab: $selectedTab)
    }
}

#Preview {
        NewCupboardPopoverPreview()
}
