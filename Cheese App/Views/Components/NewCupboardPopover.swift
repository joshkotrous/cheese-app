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
    @State var isLoading: Bool = false
    
    let client = Database.shared
    
    var body: some View {
        ZStack{
            CustomColors.background
                .ignoresSafeArea(.all)
            if isLoading {
                ProgressView() // Spinner shown when loading
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5) // Make the spinner larger if needed
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .zIndex(100)
            }
            
            VStack {
                Text("Add Cupboard")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.custom(AppConfig.fontName, size: 24))
                    .fontWeight(.bold)
                VStack(spacing: 0){
                    Text("Cupboard name")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.custom(AppConfig.fontName, size: 18))
                    TextField("", text: $newCupboardInput, prompt: Text("").foregroundColor(CustomColors.textColor).font(.custom(AppConfig.fontName, size: 18)))
                        .padding(4)
                        .foregroundColor(CustomColors.textColor)
                        .font(.custom(AppConfig.fontName, size: 18))
                        .background(RoundedRectangle(cornerRadius: 12).fill(CustomColors.tan1))
                }
     
                Button(action: {
                    Task {
                        isLoading = true
                        if (profileId != nil && newCupboardInput != "") {
                            await client.createNewCupboard(profileId: profileId ?? "", cupboardName: newCupboardInput)
                            showCupboardPopover = false
                        }
                        cupboards = await client.getUserCupboards(profileId: profileId ?? "")

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
