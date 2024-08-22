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
    init(category: String) {
        _viewModel = StateObject(wrappedValue: CategoryListViewModel(category: category))
    }

    var body: some View {
        NavigationStack{
            ZStack{
                Text("Hello, World!")
                List(viewModel.cheeses) { cheese in
                    NavigationLink(destination: CheeseDetailView(cheese: cheese)){
                        VStack(alignment: .leading) {
                            Text(cheese.name!)
                                .font(.headline)
                                .foregroundColor(CustomColors.textColor)
                            Text(cheese.category!)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 5)
                    }
                    .listRowBackground(CustomColors.tan1)
                }
                .background(CustomColors.background)
                .scrollContentBackground(.hidden)
            }
        }
        .tint(Color(CustomColors.tan2))
        .task {
            await viewModel.getCheesesForCategory(category: viewModel.category)
        }
    }
}

#Preview {
    CategoryListView(category: "Brie & Creamy")
}
