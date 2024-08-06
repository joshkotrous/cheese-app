//
//  HomeView.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/4/24.
//

import SwiftUI

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


struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var isLoading: Bool = false

    var body: some View {
        NavigationView{
            VStack(spacing: 0){
                SearchBar()
                ZStack{
                    ScrollView {
                        VStack{
                            Text("Trending")
                                .font(.custom("IowanOldStyle-Roman", size: 24))
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            VStack{
                    
                                ForEach(viewModel.cheeses.suffix(from: 0).suffix(5)) { cheese in
                                    CheeseItem(cheese: cheese)
                                }
                                
                            }
                            Text("New")
                                .font(.custom("IowanOldStyle-Roman", size: 24))
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            VStack{
                                ForEach(viewModel.cheeses.suffix(from: 0).suffix(5)) { cheese in
                                    CheeseItem(cheese: cheese)
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
        .accentColor(CustomColors.textColor)
        }
}

#Preview {
    AppView()
}
