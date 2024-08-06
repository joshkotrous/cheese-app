//
//  CheeseDetailView.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/5/24.
//

import SwiftUI

struct CheeseDetailView: View {
    let cheese: Cheese
    
    var body: some View {
        ZStack{
            CustomColors.background
                .ignoresSafeArea(.all)
            ScrollView{
                VStack(alignment: .leading) {
                    Text(cheese.name!)
                        .font(.custom("IowanOldStyle-Roman", size: 32))
                        .fontWeight(.bold)
                        .padding(.bottom, 8)
                    Text(cheese.category!)
                        .font(.custom("IowanOldStyle-Roman", size: 24))
                        .fontWeight(.semibold)
                        .padding(.bottom, 8)
                    Text(cheese.description!)
                        .font(.custom("IowanOldStyle-Roman", size: 20))
                    Spacer()
                }
                .foregroundColor(CustomColors.textColor)
                .padding()
            }
        }

    }
}


#Preview {

//    CheeseDetailView(cheese: Cheese(
//        id: "123",
//        name: "Cheddar",
//        category: "Hard Cheese",
//        url: "",
//        description: "A popular hard cheese with a sharp taste.",
//        notes:"",
//        allergens: "",
//        ingredients: "",
//        additionalFacts: ""
//    ))
    HomeView()
}
