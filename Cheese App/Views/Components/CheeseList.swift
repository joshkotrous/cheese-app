//
//  CheeseList.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/22/24.
//

import SwiftUI
enum CheeseVar {
    case cheeseValue([Cheese])
    case cupboardCheeseListValue([CupboardCheeseList])
}
struct CheeseList: View {
    @Binding var cheeses: CheeseVar
    var body: some View {
        switch cheeses {
        case .cheeseValue(let cheeses):
            List(cheeses) { cheese in
                NavigationLink(destination: CheeseDetailView(cheese: cheese)){
                    VStack(alignment: .leading) {
                        Text(cheese.name)
                            .font(.headline)
                            .foregroundColor(CustomColors.textColor)
                        Text(cheese.category)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 5)
                }
                .listRowBackground(CustomColors.tan1)
            }
            .background(CustomColors.background)
            .scrollContentBackground(.hidden)
        case .cupboardCheeseListValue(let cheeses):
            List(cheeses) { cupboardCheese in
                if let cheese = cupboardCheese.cheese {
                    NavigationLink(destination: CheeseDetailView(cheese: cheese)) {
                        VStack(alignment: .leading) {
                            Text(cheese.name ?? "")
                                .font(.headline)
                                .foregroundColor(CustomColors.textColor)
                            Text(cheese.category ?? "")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 5)
                    }
                    .listRowBackground(CustomColors.tan1)
                }
            }
            .background(CustomColors.background)
            .scrollContentBackground(.hidden)
        }
  
    }
}

//#Preview {
//    CheeseList()
//}
