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
    @Published var cupboardName: String
    init(cupboardId: String, showAddCheeseButton: Bool, selectedTab: Binding<Tab>, cupboardName: String) {
        self.cupboardId = cupboardId
        self.showAddCheeseButton = showAddCheeseButton
        self._selectedTab = selectedTab
        self.cupboardName = cupboardName

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
    
    init(cupboardId: String, selectedTab: Binding<Tab>, showAddCheeseButton: Bool, cupboardName: String) {
        _viewModel = StateObject(wrappedValue: CupboardListViewModel(cupboardId: cupboardId, showAddCheeseButton: showAddCheeseButton, selectedTab: selectedTab, cupboardName: cupboardName))
    }
    
    var body: some View {
        NavigationStack {
            VStack{
                //                CheeseList(cheeses: viewModel.cheeses)
                if (viewModel.cheeses.count == 0){
                    Text("No cheeses added yet")
                        .font(.custom(AppConfig.fontName, size: 20))
                    
                    if (viewModel.showAddCheeseButton) {
                        Button(action: {
                            viewModel.selectedTab = Tab.search
                        }){
                            Text("Add Cheese")
                                .padding()
                                .font(.custom(AppConfig.fontName, size: 20))
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
    .toolbar {
        ToolbarItem(placement: .principal, content: {       Text(viewModel.cupboardName)
                  .font(.custom(AppConfig.fontName, size: 24))
                  .foregroundColor(CustomColors.textColor)})
     

    

     
    }


        .task {
            await viewModel.getCheesesForCupboard(cupboardId: viewModel.cupboardId)
        }
    }
    
}


struct CupboardListViewPreview: View {
    @State private var selectedTab: Tab = .home
    @State private var cupboardName: String = "Test Cupboard"
    var body: some View {
        CupboardListView(cupboardId: "0cb474ab-b85c-49cd-8b31-b3089ab196da", selectedTab: $selectedTab, showAddCheeseButton: true, cupboardName: cupboardName)
    }
}

#Preview {
    CupboardListViewPreview()
}

