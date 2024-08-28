//
//  SearchBar.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/4/24.
//

import SwiftUI
import Combine

class CheeseSearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var searchResults: [Cheese] = []
    @Published var isSearched: Bool = false
    @Published var isLoading: Bool = true
    func searchForCheese() async {
        // Replace with your actual search logic
        if searchText.isEmpty {
            searchResults = [] // Clear results if query is empty
        } else {
            self.isLoading = true
            // Simulate fetching data
             let results = await Database().searchForCheeses(query: searchText)
            DispatchQueue.main.async {
                self.searchResults = results
                print(self.searchResults)
                self.isLoading = false

            }
            
        }
    }
}

struct SearchBar: View {
    @State private var isFocused: Bool = false
    @FocusState private var textFieldIsFocused: Bool // Focus state for the TextField
    @StateObject var viewModel = CheeseSearchViewModel() // Create an instance of the view model
    
    var body: some View {
        ZStack{
            Color.black
                .opacity((viewModel.isSearched || isFocused ) ? 0.5 : 0.0) // Adjust opacity when focused
                .edgesIgnoringSafeArea(.all)
                .animation(.easeInOut(duration: 0.2), value: isFocused) // Smooth animation
            VStack(spacing: 0){
                ZStack{
                    Color(CustomColors.tan1)
                        .edgesIgnoringSafeArea(.all)
                    
                    HStack{
                        Image("BiSearchAlt2")
                            .resizable()
                            .frame(width: 25)
                            .frame(height: 25)
                        
                        TextField("", text: $viewModel.searchText, prompt: Text("Cheese name, type, or monger").foregroundColor(CustomColors.textColor).font(.custom(AppConfig.fontName, size: 18)))
                            .foregroundColor(CustomColors.textColor)
                            .font(.custom(AppConfig.fontName, size: 18))
                            .focused($textFieldIsFocused) // Bind focus state to TextField
                            .onChange(of: textFieldIsFocused) { newValue in
                                isFocused = newValue // Update isFocused based on TextField focus state
                                if (viewModel.searchText.isEmpty) {
                                    viewModel.isSearched = false
                                }
                            }
                            .onSubmit {
                                Task {
                                    if(!viewModel.searchText.isEmpty){
                                        await viewModel.searchForCheese() // Trigger search when return is pressed
                                        viewModel.isSearched = true
                                    }
                                }
                            }
                    }
                    .padding()
                    .background(.white)
                    .frame(width: 325)
                    .frame(height: 35)
                    .cornerRadius(100.0)
                }
                .offset(x: 0, y: 0)
                .frame(height: 75)
                
                if(!viewModel.searchText.isEmpty && viewModel.isSearched) {
                    
                    if (viewModel.isLoading) {
                        ProgressView() // Spinner shown when loading
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.5) // Make the spinner larger if needed
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                    } else if(viewModel.searchResults.count == 0){
                        Text("No results found")
                            .frame(maxHeight: .infinity)
                            .foregroundColor(.white)
                    } else {
                        List(viewModel.searchResults) { cheese in
                            NavigationLink(destination: CheeseDetailView(cheese: cheese)) {
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
                            .listRowBackground(CustomColors.background)
                            
                        }
                        .background(CustomColors.background)
                        .scrollContentBackground(.visible)
                        .listStyle(PlainListStyle())
                        .padding(0)
                        
                    }
                
                    
                    
                    
                } else {
                    Spacer()

                }
                
            }
        }
    }
}

#Preview {
    HomeView()
}
