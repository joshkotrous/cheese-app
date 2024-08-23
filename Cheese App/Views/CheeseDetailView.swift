//
//  CheeseDetailView.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/5/24.
//

import SwiftUI

struct CheeseDetailView: View {
    let cheese: Cheese
    @State var cupboards: [Cupboard]?
    @State var selectedOption: Cupboard?
    @AppStorage("profileId") var profileId: String?
    @State private var selectedView: String?
    
    
    var body: some View {
        ZStack{
            CustomColors.background
                .ignoresSafeArea(.all)
            ScrollView{
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading) {
                        
                        
                        Text(cheese.name ?? "")
                            .font(.custom(AppConfig.fontName, size: 32))
                            .fontWeight(.bold)
                            .padding(.bottom, 8)
                        Text(cheese.category ?? "")
                            .font(.custom(AppConfig.fontName, size: 24))
                            .fontWeight(.semibold)
                            .padding(.bottom, 8)
                        
                        Menu(content: {
                            
                            Section {
                                ForEach(cupboards ?? []) { cupboard in
                                    if(cupboard.name != "Created By Me") {
                                        Button(action: {
                                            selectedOption = cupboard
                                            Task {
                                                if (cupboard.id != nil && cheese.id != nil) {
                                                    await Database().addCheeseToCupboard(cupboardId: cupboard.id!, cheeseId: cheese.id!)
                                                }
                                                
                                            }
                                        }) {
                                            Text(cupboard.name!)
                                        }
                                    }
                                }
                                
                            }
                            
                            Picker(selection: $selectedView,
                                   label: Text("Picker")
                            ) {
                                
                            }
                            
                            
                        }, label: {
                            HStack{
                                Text("Add to Cupboard")
                                Image(systemName: "chevron.down")
                            }.padding()
                                .background(CustomColors.tan1)
                                .cornerRadius(16.0)
                        }).menuStyle(.button)
                        
                        Text(cheese.description ?? "")
                            .font(.custom(AppConfig.fontName, size: 20))
                    }
                    Text("Reviews")
                        .font(.custom(AppConfig.fontName, size: 24))
                        .fontWeight(.bold)
                    Spacer()
                }
                .foregroundColor(CustomColors.textColor)
                .padding()
            }
        }
        .task {
            if(profileId != nil && profileId != "") {
                cupboards = await Database().getUserCupboards(profileId: profileId!)
                
            }
        }
        
    }
    
}


#Preview {
    
    CheeseDetailView(cheese: Cheese(
        id: "123",
        name: "Cheddar",
        category: "Hard Cheese",
        url: "",
        description: "A popular hard cheese with a sharp taste.",
        notes:"",
        allergens: "",
        ingredients: "",
        additionalFacts: ""
    ))
    //    HomeView()
}

