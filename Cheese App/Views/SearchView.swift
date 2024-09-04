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
    @Published var isLoading: Bool = true
    let client = Database.shared

    func getAllCategories() async {
            let fetchedCategories =  await client.getAllCategories()
            DispatchQueue.main.async {
                self.categories = fetchedCategories
            }
     
    }
    
    func getAllGateways() async {
            let fetchedGateways =  await client.getAllGateways()
            DispatchQueue.main.async{
                self.gateways = fetchedGateways
            }

    }
}

struct SearchView: View {
    @State private var opacity: Double = 0.0
    @StateObject private var viewModel = SearchViewModel()

    var body: some View {
        NavigationStack {
            ZStack{
                
            
            VStack(spacing: 0) {

                ZStack {
                    CustomColors.background
                        .ignoresSafeArea(.all)
                    if viewModel.isLoading {
                        ProgressView() // Spinner shown when loading
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.5) // Make the spinner larger if needed
                    } else {

                        let columns: [GridItem] = [
                            GridItem(.fixed(110)),
                            GridItem(.fixed(110)),
                            GridItem(.fixed(110))
                        ]
                        ScrollView(.vertical) {
                            VStack(spacing: 30) {
                                VStack {
                                    Spacer(minLength: 75)

                                    Text("Categories")
                                        .font(.custom(AppConfig.fontName, size: 24))
                                        .fontWeight(.bold)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding()
                                    
                                    LazyVGrid(columns: columns, spacing: 20) {
                                        ForEach(viewModel.categories) { category in
                                            NavigationLink(destination: CategoryListView(category: category.category)) {
                                                Text(category.category)
                                                    .font(.custom(AppConfig.fontName, size: 14))
                                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                    .padding()
                                            }
                                            .background(CustomColors.tan1)
                                            .frame(width: 110, height: 110)
                                            .opacity(opacity) // Apply the opacity here
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(CustomColors.textColor, lineWidth: 2)
                                                    .opacity(opacity)
                                            )
                                            .onAppear {
                                                withAnimation(.easeInOut(duration: 0.5)) {
                                                    opacity = 1.0
                                                }
                                            }
                                            .cornerRadius(12)
                                        }
                                    }
                                    VStack {
                                        Text("Gateways")
                                            .font(.custom(AppConfig.fontName, size: 24))
                                            .fontWeight(.bold)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding()
                                        
                                        LazyVGrid(columns: columns, spacing: 20) {
                                            ForEach(viewModel.gateways) { gateway in
                                                NavigationLink(destination: CategoryListView(category: gateway.gateway)) {
                                                    Text(gateway.gateway)
                                                        .font(.custom(AppConfig.fontName, size: 14))
                                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                        .padding()
                                                }
                                                .background(CustomColors.tan1)
                                                .frame(width: 110, height: 110)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .stroke(CustomColors.textColor, lineWidth: 2)
                                                        .opacity(opacity)
                                                )
                                                .onAppear {
                                                    withAnimation(.easeInOut(duration: 0.5)) {
                                                        opacity = 1.0
                                                    }
                                                }
                                                .cornerRadius(12)
                                            }
                                        }
                                    }
                                }
                                .padding(.bottom)
                            }
                            .foregroundColor(CustomColors.textColor)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    VStack{
                        SearchBar()

                    }
                }
                }
                .task {
                    await viewModel.getAllCategories()
                    await viewModel.getAllGateways()
                    viewModel.isLoading = false
                }
            }
            .tint(Color(CustomColors.tan2))
        }
    }
}

#Preview {
    SearchView()
}
