//
//  CategoryListView.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/10/24.
//
import SwiftUI

class CupboardListViewModel: ObservableObject {
    @Published var cupboardId: String
    @Published var cheeses: [CupboardCheeseList] = []

    init(cupboardId: String) {
        self.cupboardId = cupboardId
    }
    
    func getCheesesForCupboard(cupboardId: String) async {
        let fetchedCheeses = await Database().getCheesesForCupboard(cupboardId: cupboardId)
        DispatchQueue.main.async {
            self.cheeses = fetchedCheeses
        }
    }
}

struct CupboardListView: View {
    @StateObject private var viewModel: CupboardListViewModel

    init(cupboardId: String) {
        _viewModel = StateObject(wrappedValue: CupboardListViewModel(cupboardId: cupboardId))
    }

    var body: some View {
        NavigationStack {

//                CheeseList(cheeses: viewModel.cheeses)
                List(viewModel.cheeses) { cupboardCheese in
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
                        .listRowBackground(CustomColors.background)
                    }
                }
                .background(CustomColors.background)
                .scrollContentBackground(.hidden)
                .listStyle(PlainListStyle())
            }
        

        .tint(Color(CustomColors.tan2))
        .task {
            await viewModel.getCheesesForCupboard(cupboardId: viewModel.cupboardId)
        }
    }
}

#Preview {
    CupboardListView(cupboardId: "sample-cupboard-id")
}
