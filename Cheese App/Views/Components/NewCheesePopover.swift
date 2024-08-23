//
//  NewCheesePopover.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/5/24.
//

import SwiftUI

class NewCheesePopoverModel: ObservableObject {
    @Published var categories: [Category] = []
    @Published var selectedCategory: String = "Cheese Category"
    @Published var cheeseName: String = ""
    @Published var description: String = ""
    @Published var notes: String = ""
    
}

struct NewCheesePopover: View {

    @StateObject var viewModel = NewCheesePopoverModel()
    
   
    
    var body: some View {
   
        ZStack{
            CustomColors.background
                .ignoresSafeArea(.all)
            VStack {
                Text("Add Cheese")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.custom("IowanOldStyle-Roman", size: 24))
                    .fontWeight(.bold)
                Text("Cheese name")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.custom("IowanOldStyle-Roman", size: 18))
                TextField("", text: $viewModel.cheeseName, prompt: Text("").foregroundColor(CustomColors.textColor).font(.custom("IowanOldStyle-Roman", size: 18)))
                    .foregroundColor(CustomColors.textColor)
                    .padding(4)
                    .font(.custom("IowanOldStyle-Roman", size: 18))
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(CustomColors.textColor, lineWidth: 1)
                        
                    }
               
                
                Menu(content: {
                    
                    ForEach(viewModel.categories) { category in
                        Button(action:{
                            viewModel.selectedCategory = category.category
                        }){
                            Text(category.category)
                        }
                        
                    }
                    
                    Button(action:{}){
                        Text("Test")
                    }
                    
                }, label: {
                    Text(viewModel.selectedCategory)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.custom("IowanOldStyle-Roman", size: 18))
                })
                
                TextField("", text: $viewModel.notes, prompt: Text("Notes").foregroundColor(CustomColors.textColor).font(.custom("IowanOldStyle-Roman", size: 18)))
                    .foregroundColor(CustomColors.textColor)
                    .font(.custom("IowanOldStyle-Roman", size: 18))
                Text("Description")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.custom("IowanOldStyle-Roman", size: 18))
                TextEditor(text: $viewModel.description)
                        .foregroundColor(CustomColors.textColor) // Set the text color
                        .font(.custom("IowanOldStyle-Roman", size: 18)) // Set the custom font and size
                        .frame(height: 100, alignment: .top)
                        .scrollContentBackground(.hidden) // <- Hide it
                        .background(CustomColors.background)
                        .padding(4)
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(CustomColors.textColor, lineWidth: 1)
                            
                        }
                    
                Button(action: {}) {
                    Text("Add")
                        .frame(maxWidth: .infinity)
                        .font(.custom("IowanOldStyle-Roman", size: 18))
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
        }.task {
            viewModel.categories = await Database().getAllCategories()
        }
    }
}

#Preview {
    NewCheesePopover()
}
