//
//  SearchView.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/4/24.
//

import SwiftUI

class SearchViewModel: ObservableObject {
    @Published var categories: [Category] = []
    @Published var gateways: [Gateway] = []
    func getAllCategories() async {
            let fetchedCategories =  await Database().getAllCategories()
            DispatchQueue.main.async {
                self.categories = fetchedCategories
            }
     
    }
    
    func getAllGateways() async {
            let fetchedGateways =  await Database().getAllGateways()
            DispatchQueue.main.async{
                self.gateways = fetchedGateways
            }

    }
}


struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    init() {
        
    }
    var body: some View {
        NavigationStack{
            VStack(spacing: 0){
                SearchBar()
                ZStack {
                    CustomColors.background
                        .ignoresSafeArea(.all)
                
                    let columns: [GridItem] = [
                        GridItem(.fixed(110)),
                        GridItem(.fixed(110)),
                        GridItem(.fixed(110))
                    ]
                    ScrollView(.vertical) {
                        VStack(spacing: 30){
                            VStack{
                                Text("Categories")
                                    .font(.custom("IowanOldStyle-Roman", size: 24))
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                                    .padding()
                                LazyVGrid(columns: columns, spacing: 20) {
                                    ForEach(viewModel.categories) { category in
                                        NavigationLink(destination: CategoryListView(category: category.category)){
                                            Text(category.category).font(.custom("", size: 16))
                                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                .padding()
                                            
                                            
                                            
                                        }
                                        .background(CustomColors.tan1)
                                        .frame(width: 110, height: 110)
                                        .overlay( /// apply a rounded border
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(CustomColors.textColor, lineWidth: 2)
                                        )
                                        .cornerRadius(12)
                                        
                                        
                                        
                                    }
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    
                                    
                                }
                                VStack{
                                    
                                    Text("Gateways")
                                        .font(.custom("IowanOldStyle-Roman", size: 24))
                                        .fontWeight(.bold)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                                        .padding()
                                    LazyVGrid(columns: columns, spacing: 20) {
                                        ForEach(viewModel.gateways) { gateway in
                                            NavigationLink(destination: CategoryListView(category: gateway.gateway)){
                                                Text(gateway.gateway).font(.custom("", size: 16))
                                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                    .padding()
                                                
                                                
                                                
                                            }
                                            .background(CustomColors.tan1)
                                            .frame(width: 110, height: 110)
                                            .overlay( /// apply a rounded border
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(CustomColors.textColor, lineWidth: 2)
                                            )
                                            .cornerRadius(12)
                                            
                                        }
                                    }
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    
                                }
                            }
                            .padding(.bottom)
                        }
                        .foregroundColor(CustomColors.textColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .task {
                await viewModel.getAllCategories()
                await viewModel.getAllGateways()
            }
        }
        .tint(Color(CustomColors.tan2))
        
    }
    
}

#Preview {
    SearchView()
}
