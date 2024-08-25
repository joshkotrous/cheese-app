//
//  CategoryListView.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/10/24.
//

import SwiftUI

class CategoryListViewModel: ObservableObject {
    @Published var category: String
    @Published var cheeses: [Cheese] = []
    
    init(category: String) {
        self.category = category
    }
    func getCheesesForCategory(category: String) async {
            let fetchedCheeses =  await Database().getCheesesByCategory(category: category)
            DispatchQueue.main.async {
                self.cheeses = fetchedCheeses
            }
            print(fetchedCheeses)

    }
}

struct CategoryListView: View {
    @StateObject private var viewModel: CategoryListViewModel
    @State var isLoading: Bool = true
    init(category: String) {
        _viewModel = StateObject(wrappedValue: CategoryListViewModel(category: category))
    }

    var body: some View {
        NavigationStack{
            if isLoading {
                VStack{
                    ProgressView() // Spinner shown when loading
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5) // Make the spinner larger if needed
                }.frame(maxWidth: .infinity, maxHeight: .infinity).background(CustomColors.background)
            } else {
                List(viewModel.cheeses) { cheese in
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
                    .listRowBackground(CustomColors.background)
                }
                .background(CustomColors.background)
                .scrollContentBackground(.hidden)
                .listStyle(PlainListStyle())
            }
            
        }
        .tint(Color(CustomColors.tan2))
        .task {
            isLoading = true
            await viewModel.getCheesesForCategory(category: viewModel.category)
            isLoading = false
        }
        .toolbar {
            ToolbarItem(placement: .principal, content: {       Text(viewModel.category)
                     .font(.custom(AppConfig.fontName, size: 24))
                     .foregroundColor(CustomColors.textColor)})
        

       

        
       }
    }
}

#Preview {
    CategoryListView(category: "Brie & Creamy")
}
