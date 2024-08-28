//
//  HomeView.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/4/24.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var cheeses: [Cheese] = []
    @Published var isLoading: Bool = true
    func getAllCheeses() async {
        let fetchedCheeses = await Database().getAllCheeses()
        DispatchQueue.main.async {
            self.cheeses = fetchedCheeses
        }
        
    }
}


struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    
    var body: some View {
        NavigationView {
            ZStack{
                
                
                VStack(spacing: 0){
                    Spacer(minLength: 75)

                    ZStack{
                        if viewModel.isLoading {
                            VStack{
                                ProgressView() // Spinner shown when loading
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .scaleEffect(1.5) // Make the spinner larger if needed
                            }.frame(maxWidth: .infinity, maxHeight: .infinity).background(CustomColors.background)
                            
                        } else {
                            ScrollView {
                                VStack{
                                    VStack{
                                        Text("New This Week")
                                            .font(.custom(AppConfig.fontName, size: 24))
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
                            .background(CustomColors.background)
                            .frame(maxHeight: .infinity)
                        }
                        
                    }
                    
                }
                .ignoresSafeArea(.keyboard)
                .frame(maxHeight: .infinity)
                .foregroundColor(CustomColors.textColor)
                
                VStack{
                    SearchBar()
                    
                }

                
            }
            .task {
                await viewModel.getAllCheeses()
                viewModel.isLoading = false
            }        .accentColor(CustomColors.textColor)
            
        }
    }
    
    
}


#Preview {
    AppView()
}
