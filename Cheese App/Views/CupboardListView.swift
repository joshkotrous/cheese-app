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
    @Binding var selectedTab: Tab
    @Published var cupboardName: String
    init(cupboardId: String, selectedTab: Binding<Tab>, cupboardName: String) {
        self.cupboardId = cupboardId
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
    @State var showSearchPopover: Bool = false
    @State var isLoading: Bool = true
    @State var idToDelete: String = ""
    @AppStorage("userId") var userId: String?
    init(cupboardId: String, selectedTab: Binding<Tab>, cupboardName: String) {
        _viewModel = StateObject(wrappedValue: CupboardListViewModel(cupboardId: cupboardId, selectedTab: selectedTab, cupboardName: cupboardName))
    }
    
    var body: some View {
        NavigationStack {
            if isLoading {
                VStack{
                    ProgressView() // Spinner shown when loading
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5) // Make the spinner larger if needed
                }.frame(maxWidth: .infinity, maxHeight: .infinity).background(CustomColors.background)
            } else {
                VStack{
                    if (viewModel.cheeses.count == 0){
                        
                        
                        if (viewModel.cupboardName != AppConfig.reviewedByMe){
                            Text("No cheeses added yet")
                                .font(.custom(AppConfig.fontName, size: 20))
                        } else {
                            Text("No cheeses reviewed yet")
                                .font(.custom(AppConfig.fontName, size: 20))
                        }
                        
                        
                        
                        
                        if (viewModel.cupboardName != AppConfig.createByMe) {
                            if(viewModel.cupboardName != AppConfig.reviewedByMe){
                                HStack{
                                    Button(action: {
                                        showSearchPopover = true
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
                        if (viewModel.cupboardName != AppConfig.reviewedByMe){
                            List {
                                ForEach(viewModel.cheeses) { cupboardCheese in
                                    if let cheese = cupboardCheese.cheese {
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
                                    
                                }
                                
                                .onDelete(perform: { indexSet in
                                    for index in indexSet {
                                        let cupboardCheese = viewModel.cheeses[index]
                                        if let cheeseIdToDelete = cupboardCheese.cheese?.id {
                                            let cupboardIdToDelete = cupboardCheese.id
                                            if viewModel.cupboardName == AppConfig.createByMe {
                                                Task {
                                                    idToDelete = cheeseIdToDelete
                                                    showAlert = true
                                                    //                                                await Database().deleteUserCheese(cheeseId: cheeseIdToDelete, userId: userId ?? "")
                                                    //                                                await viewModel.getCheesesForCupboard(cupboardId: viewModel.cupboardId)
                                                }
                                            } else {
                                                Task {
                                                    await Database().deleteCupboardCheese(cupboardCheeseId: cupboardIdToDelete)
                                                    await viewModel.getCheesesForCupboard(cupboardId: viewModel.cupboardId)
                                                }
                                                viewModel.cheeses.remove(atOffsets: indexSet)
                                                
                                            }
                                        }
                                    }
                                    
                                    print("deleted")
                                })
                                
                            }
                            
                            .background(CustomColors.background)
                            .scrollContentBackground(.hidden)
                            .listStyle(PlainListStyle())
                        } else {
                            List {
                                ForEach(viewModel.cheeses) { cupboardCheese in
                                    if let cheese = cupboardCheese.cheese {
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
                                    
                                }
                            
                            }
                            
                            .background(CustomColors.background)
                            .scrollContentBackground(.hidden)
                            .listStyle(PlainListStyle())
                        }
              
                    }
                    
                    
                    
                }
                .foregroundColor(CustomColors.textColor)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(CustomColors.background)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Delete Cheese"),
                        message: Text("Deleting a cheese from " + AppConfig.createByMe + " will delete it in its entirety."),
                        primaryButton: .destructive(Text("Delete")) {
                            Task{
                                await Database().deleteUserCheese(cheeseId: idToDelete, userId: userId ?? "")
                                await viewModel.getCheesesForCupboard(cupboardId: viewModel.cupboardId)
                            }
                            print("Account deleted")
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
        }
        .tint(Color(CustomColors.tan2))
        .toolbar {
            ToolbarItem(placement: .principal, content: {       Text(viewModel.cupboardName)
                    .font(.custom(AppConfig.fontName, size: 24))
                .foregroundColor(CustomColors.textColor)})
            
            
            
            
            
        }
        .popover(isPresented: $showCheesePopover) {
            NewCheesePopover(showNewCheesePopover: $showCheesePopover, cupboardId: viewModel.cupboardId, cupboardName: viewModel.cupboardName).onDisappear(perform: {
                Task{
                    await viewModel.getCheesesForCupboard(cupboardId: viewModel.cupboardId)
                }
            })
        }
        .popover(isPresented: $showSearchPopover) {
            SearchView().onDisappear {
                showSearchPopover = false
                Task{
                    await viewModel.getCheesesForCupboard(cupboardId: viewModel.cupboardId)
                }
            }
        }
        .task {
            isLoading = true
            await viewModel.getCheesesForCupboard(cupboardId: viewModel.cupboardId)
            isLoading = false
        }
    }
    
}


struct CupboardListViewPreview: View {
    @State private var selectedTab: Tab = .home
    @State private var cupboardName: String = "Test Cupboard"
    var body: some View {
        CupboardListView(cupboardId: "0cb474ab-b85c-49cd-8b31-b3089ab196da", selectedTab: $selectedTab, cupboardName: cupboardName)
    }
}

#Preview {
    CupboardListViewPreview()
}

