//
//  NewCheesePopover.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/5/24.
//

import SwiftUI

struct NewCheesePopover: View {
    @State private var cheeseName = ""
    @State private var cheeseType = ""
    @State private var notes = ""
    @State private var description = ""

    
    var body: some View {
        ZStack{
            CustomColors.background
                .ignoresSafeArea(.all)
            VStack {
                Text("Add Cheese")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.custom("IowanOldStyle-Roman", size: 24))
                TextField("", text: $cheeseName, prompt: Text("Cheese name").foregroundColor(CustomColors.textColor).font(.custom("IowanOldStyle-Roman", size: 18)))
                    .foregroundColor(CustomColors.textColor)
                    .font(.custom("IowanOldStyle-Roman", size: 18))
                TextField("", text: $cheeseType, prompt: Text("Cheese type").foregroundColor(CustomColors.textColor).font(.custom("IowanOldStyle-Roman", size: 18)))
                    .foregroundColor(CustomColors.textColor)
                    .font(.custom("IowanOldStyle-Roman", size: 18))
                TextField("", text: $notes, prompt: Text("Notes").foregroundColor(CustomColors.textColor).font(.custom("IowanOldStyle-Roman", size: 18)))
                    .foregroundColor(CustomColors.textColor)
                    .font(.custom("IowanOldStyle-Roman", size: 18))
                TextField("", text: $description, prompt: Text("Description").foregroundColor(CustomColors.textColor).font(.custom("IowanOldStyle-Roman", size: 18)))
                    .foregroundColor(CustomColors.textColor)
                    .font(.custom("IowanOldStyle-Roman", size: 18))
                    .frame(height: 100, alignment: .top)
                Button(action: {}) {
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
    NewCheesePopover()
}
