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
    @State var showAlert: Bool = false
    @State var showCheesePopover: Bool = false
    @State var idToDelete: String = ""
    @AppStorage("userId") var userId: String?
    init(cupboardId: String, selectedTab: Binding<Tab>, showAddCheeseButton: Bool, cupboardName: String) {
        _viewModel = StateObject(wrappedValue: CupboardListViewModel(cupboardId: cupboardId, showAddCheeseButton: showAddCheeseButton, selectedTab: selectedTab, cupboardName: cupboardName))
    }
    
    var body: some View {
        NavigationStack {
            VStack{
               if (viewModel.cheeses.count == 0){
                    Text("No cheeses added yet")
                        .font(.custom(AppConfig.fontName, size: 20))
                    
  
                   
                    if (viewModel.showAddCheeseButton) {
                        HStack{
                            Button(action: {
                                viewModel.selectedTab = Tab.search
                            }){
                                Text("Add From Database")
                                    .padding()
                                    .font(.custom(AppConfig.fontName, size: 16))
                                    .background(CustomColors.tan1)
                            }
                            .cornerRadius(16)
                            Button(action: {
                                showCheesePopover = true
                            }){
                                Text("Add New Cheese")
                                    .padding()
                                    .font(.custom(AppConfig.fontName, size: 16))
                                    .background(CustomColors.tan1)
                            }
                            .cornerRadius(16)
                        }
                    } else {
                        Button(action: {
                            showCheesePopover = true
                        }){
                            Text("Add New Cheese")
                                .padding()
                                .font(.custom(AppConfig.fontName, size: 16))
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
                            for index in indexSet {
                                let cupboardCheese = viewModel.cheeses[index]
                                if let cheeseIdToDelete = cupboardCheese.cheese?.id {
                                    let cupboardIdToDelete = cupboardCheese.id
                                    if viewModel.cupboardName == "Created By Me" {
                                        showAlert = true
                                        Task {
                                            await Database().deleteUserCheese(cheeseId: cheeseIdToDelete, userId: userId ?? "")
                                            await viewModel.getCheesesForCupboard(cupboardId: viewModel.cupboardId)
                                        }
                                    } else {
                                        Task {
                                            await Database().deleteCupboardCheese(cupboardCheeseId: cupboardIdToDelete)
                                            await viewModel.getCheesesForCupboard(cupboardId: viewModel.cupboardId)
                                        }
                                    }
                                }
                            }
                            viewModel.cheeses.remove(atOffsets: indexSet)
                            
                            print("deleted")
                        })
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Delete Account"),
                                message: Text("Are you sure you want to delete your account?"),
                                primaryButton: .destructive(Text("Delete")) {
                                    Task{
                                        await Database().deleteUserCheese(cheeseId: idToDelete, userId: userId ?? "")
                                    }
                                    print("Account deleted")
                                },
                                secondaryButton: .cancel()
                            )
                        }
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
        .popover(isPresented: $showCheesePopover) {
            NewCheesePopover(showNewCheesePopover: $showCheesePopover).onDisappear(perform: {
                Task{
                    await viewModel.getCheesesForCupboard(cupboardId: viewModel.cupboardId)
                }
            })
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

