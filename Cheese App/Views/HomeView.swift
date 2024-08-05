//
//  HomeView.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/4/24.
//

import SwiftUI

struct CheeseView: View {
    let cheese: Cheese
    var body: some View {
        ZStack{
            CustomColors.tan1
            VStack {
                Text(cheese.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.custom("IowanOldStyle-Roman", size: 24))
                Text(cheese.category)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.custom("IowanOldStyle-Roman", size: 18))
                Text(cheese.description)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.custom("IowanOldStyle-Roman", size: 16))
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
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

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        VStack(spacing: 0){
            SearchBar()
            ZStack{
                ScrollView {
                    VStack{
                        Text("Trending")
                            .font(.custom("IowanOldStyle-Roman", size: 24))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        VStack{
                
                            ForEach(viewModel.cheeses.suffix(from: 0).suffix(5)) { cheese in
                                CheeseView(cheese: cheese)
                            }
                            
                        }
                        Text("New")
                            .font(.custom("IowanOldStyle-Roman", size: 24))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        VStack{
                            ForEach(viewModel.cheeses.suffix(from: 0).suffix(5)) { cheese in
                                CheeseView(cheese: cheese)
                            }
                            
                        }
                    }
                    .padding()
                }
                .background(CustomColors.background)

            }
            .foregroundColor(CustomColors.textColor)
        }
        .task {
                await viewModel.getAllCheeses()
            }
        }
}

class HomeViewModel: ObservableObject {
    @Published var cheeses: [Cheese] = []
     
     func getAllCheeses() async {
         do {
             let fetchedCheeses = try await Database().getAllCheeses()
             DispatchQueue.main.async {
                 self.cheeses = fetchedCheeses
             }
         } catch {
             print("Error fetching cheeses: \(error)")
         }
     }
}


#Preview {
    AppView()
}
