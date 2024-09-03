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
    @State private var description: String = ""
    @State private var rating: Double = 0.0
    
    var body: some View {
        ZStack{
            CustomColors.background
                .ignoresSafeArea(.all)
            ScrollView{
                
                VStack(alignment: .leading, spacing: 20) {
                    if let imageUrl = cheese.image {
                        VStack{
                            VStack{
                                AsyncImage(url: URL(string: imageUrl)) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
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
                                .aspectRatio(contentMode: .fill)
                                .cornerRadius(24)
                                
                                
                            }    .frame(width: 250, height: 250)
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
                    VStack(alignment: .leading, spacing: 8){
                        Text("My Review")
                            .font(.custom(AppConfig.fontName, size: 24))
                            .fontWeight(.bold)
                        HStack{
                            Button(action: {
                                if (rating == 0.0){
                                    rating = 0.5
                                } else if (rating == 0.5) {
                                    rating = 1

                                } else {
                                    rating = 0.0
                                }
                            }) {
                                if (rating == 0.5){
                                    Image("StarHalfFill")

                                } else if (rating >= 1) {
                                    Image("StarFill")

                                } else {
                                    Image("StarEmpty")
                                }
                            }
                            Button(action: {
                                if (rating == 0.0){
                                    rating = 1.5
                                } else if (rating == 1.5) {
                                    rating = 2

                                } else {
                                    rating = 1.5
                                }
                            }) {
                                if (rating == 1.5){
                                    Image("StarHalfFill")

                                } else if (rating >= 2) {
                                    Image("StarFill")

                                } else {
                                    Image("StarEmpty")
                                }
                            }
                            Button(action: {
                                if (rating == 0.0){
                                    rating = 2.5
                                } else if (rating == 2.5) {
                                    rating = 3

                                } else {
                                    rating = 2.5
                                }
                            }) {
                                if (rating == 2.5){
                                    Image("StarHalfFill")

                                } else if (rating >= 3) {
                                    Image("StarFill")

                                } else {
                                    Image("StarEmpty")
                                }
                            }
                            Button(action: {
                                if (rating == 0.0){
                                    rating = 3.5
                                } else if (rating == 3.5) {
                                    rating = 4

                                } else {
                                    rating = 3.5
                                }
                            }) {
                                if (rating == 3.5){
                                    Image("StarHalfFill")

                                } else if (rating >= 4) {
                                    Image("StarFill")

                                } else {
                                    Image("StarEmpty")
                                }
                            }
                            Button(action: {
                                if (rating == 0.0){
                                    rating = 4.5
                                } else if (rating == 4.5) {
                                    rating = 5

                                } else {
                                    rating = 4.5
                                }
                            }) {
                                if (rating == 4.5){
                                    Image("StarHalfFill")

                                } else if (rating >= 5) {
                                    Image("StarFill")

                                } else {
                                    Image("StarEmpty")
                                }
                            }
                            Text("\(String(format: "%.1f", rating))").font(.custom("", size: 20))
                      
                      

                        }
                        VStack(spacing: 2){
                            Text("Description")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.custom(AppConfig.fontName, size: 18))
                            TextEditor(text: $description)
                                    .foregroundColor(CustomColors.textColor) // Set the text color
                                    .font(.custom(AppConfig.fontName, size: 18)) // Set the custom font and size
                                    .frame(height: 100, alignment: .top)
                                    .scrollContentBackground(.hidden) // <- Hide it
                                    .cornerRadius(12)
                                    .background(RoundedRectangle(cornerRadius: 12).fill(CustomColors.tan1))


                        }
                        Button(action: {}){
                            Text("Add Review")
                                .padding(8)
                                .frame(maxWidth: .infinity)
                                .background(CustomColors.button)
                                .cornerRadius(12)
                        }
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
        id: "e982925f-c735-4289-820c-03c932f0840a",
        name: "Cheddar",
        category: "Hard Cheese",
        url: "",
        description: "A popular hard cheese with a sharp taste.",
        notes:"",
        allergens: "",
        ingredients: "",
        additionalFacts: "",
        image: "https://kdbdsvrqhkmsgsgildrt.supabase.co/storage/v1/object/public/cheese_images/public/e982925f-c735-4289-820c-03c932f0840a.jpg"
    ))
    //    HomeView()
}

