//
//  CategoryListView.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/10/24.
//
import SwiftUI

class CupboardListViewModel: ObservableObject {
    @Published var cupboardId: String
    @Published var showAddCheeseButton: Bool
    @Published var cheeses: [CupboardCheeseList] = []
    @Binding var selectedTab: Tab

    init(cupboardId: String, showAddCheeseButton: Bool, selectedTab: Binding<Tab>) {
        self.cupboardId = cupboardId
        self.showAddCheeseButton = showAddCheeseButton
        self._selectedTab = selectedTab

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
    
    init(cupboardId: String, selectedTab: Binding<Tab>, showAddCheeseButton: Bool) {
        _viewModel = StateObject(wrappedValue: CupboardListViewModel(cupboardId: cupboardId, showAddCheeseButton: showAddCheeseButton, selectedTab: selectedTab))
    }
    
    var body: some View {
        NavigationStack {
            VStack{
                //                CheeseList(cheeses: viewModel.cheeses)
                if (viewModel.cheeses.count == 0){
                    Text("No cheeses added yet")
                        .font(.custom("IowanOldStyle-Roman", size: 20))
                    
                    if (viewModel.showAddCheeseButton) {
                        Button(action: {
                            viewModel.selectedTab = Tab.search
                        }){
                            Text("Add Cheese")
                                .padding()
                                .font(.custom("IowanOldStyle-Roman", size: 20))
                                .background(CustomColors.tan1)
                        }
                        .cornerRadius(16)
                    }
                    
                    
                    
                } else {
                    
                    List {
                        ForEach(viewModel.cheeses) { cupboardCheese in
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
                        .onDelete(perform: { indexSet in
                            let idsToDelete = indexSet.map { viewModel.cheeses[$0].id }
                            if (idsToDelete.count == 0){
                                return
                            }
                            viewModel.cheeses.remove(atOffsets: indexSet)
                            Task{
                                print(idsToDelete[0])
                                await Database().deleteCupboardCheese(cupboardCheeseId: idsToDelete[0])
                                
                                
                            }
                            print("deleted")
                        }) // Attach onDelete here
                    }
                    
                    .background(CustomColors.background)
                    .scrollContentBackground(.hidden)
                    .listStyle(PlainListStyle())
                }
            }
            .foregroundColor(CustomColors.textColor)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(CustomColors.background)
            
        }
        .tint(Color(CustomColors.tan2))
        .task {
            await viewModel.getCheesesForCupboard(cupboardId: viewModel.cupboardId)
        }
    }
    
}


struct CupboardListViewPreview: View {
    @State private var selectedTab: Tab = .home
    var body: some View {
        CupboardListView(cupboardId: "0cb474ab-b85c-49cd-8b31-b3089ab196da", selectedTab: $selectedTab, showAddCheeseButton: true)
    }
}

#Preview {
    CupboardListViewPreview()
}

