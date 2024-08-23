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
        let fetchedCheeses = await Database().getAllCheeses()
        DispatchQueue.main.async {
            self.cheeses = fetchedCheeses
        }
        
    }
}


struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var isLoading: Bool = false
    @State private var testInput: String = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 0){
                SearchBar()
                

            
                ZStack{
                    ScrollView {
                        VStack{
                            VStack{
                                Text("New This Week")
                                    .font(.custom("IowanOldStyle-Roman", size: 24))
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                VStack{
                                    if viewModel.cheeses.count > 0 {
                                        let cheeses = viewModel.cheeses.suffix(5)
                                        ForEach(Array(cheeses.enumerated()), id: \.element.id) { index, cheese in
                                            let delay = Double(index) * 0.1
                                            CheeseItem(delay: delay, cheese: cheese)
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                    }

                }
                .background(CustomColors.background)
                .frame(maxHeight: .infinity)

                
            }
            .ignoresSafeArea(.keyboard)
            .frame(maxHeight: .infinity)
            .foregroundColor(CustomColors.textColor)

        }
        .task {
            await viewModel.getAllCheeses()
        }        .accentColor(CustomColors.textColor)

    }


}


#Preview {
    AppView()
}
