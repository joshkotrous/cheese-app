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
                    if let imageUrl = cheese.image {
                        VStack{
                            AsyncImage(url: URL(string: imageUrl)) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                case .failure:
                                    Image(systemName: "photo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundColor(.gray)
                                @unknown default:
                                    Image(systemName: "photo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundColor(.gray)
                                }
                            }
                            .frame(width: 250, height: 250)
                            .cornerRadius(24)
                        }.frame(maxWidth: .infinity, alignment: .center)
      
                    }
                    
                    VStack(alignment: .leading) {
                        
                        
                        Text(cheese.name)
                            .font(.custom(AppConfig.fontName, size: 32))
                            .fontWeight(.bold)
                            .padding(.bottom, 8)
                        Text(cheese.category)
                            .font(.custom(AppConfig.fontName, size: 24))
                            .fontWeight(.semibold)
                            .padding(.bottom, 8)
                        
                        Menu(content: {
                            
                            Section {
                                ForEach(cupboards ?? []) { cupboard in
                                    if(cupboard.name != AppConfig.createByMe && cupboard.name != AppConfig.reviewedByMe) {
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
                        
                        Text(cheese.description)
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
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)

        .task {
            if(profileId != nil && profileId != "") {
                cupboards = await Database().getUserCupboards(profileId: profileId!)
                
            }
        }    .toolbar {
            ToolbarItem(placement: .principal, content: {       Text(cheese.name)
                      .font(.custom(AppConfig.fontName, size: 24))
                      .foregroundColor(CustomColors.textColor)})
         

        

         
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

