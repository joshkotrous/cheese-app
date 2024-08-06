//
//  CheeseItem.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/5/24.
//

import SwiftUI

struct CheeseItem: View {
    let cheese: Cheese
    var body: some View {
        NavigationLink(destination: CheeseDetailView(cheese: cheese)){
            ZStack{
                CustomColors.tan1
                VStack {
                    Text(cheese.name!)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fontWeight(.bold)
                        .font(.custom("IowanOldStyle-Roman", size: 24))
                    Text(cheese.category!)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fontWeight(.semibold)
                        .font(.custom("IowanOldStyle-Roman", size: 18))
                    Text(cheese.description!)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.custom("IowanOldStyle-Roman", size: 16))
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .padding()
                
            }
            .frame(height: 200)
            .frame(width: .infinity)
            .cornerRadius(12.0)
            .overlay( /// apply a rounded border
                RoundedRectangle(cornerRadius: 12)
                    .stroke(CustomColors.textColor, lineWidth: 1)
            )

        }
        }
}

#Preview {
    HomeView()
}
