//
//  CheeseCategoryPreferencesSelectionView.swift
//  Cheese App
//
//  Created by Josh Kotrous on 9/3/24.
//

import SwiftUI

struct SelectableCategory: Identifiable {
    let category: Category
    var isSelected: Bool
    
    var id: Int {
        category.id
    }
    
    var title: String {
        category.category
    }
}

class CheeseCategoryPreferencesSelectionViewModel: ObservableObject {
    @Published var categories: [SelectableCategory] = []  // Changed from Category to SelectableCategory
    @Published var gateways: [Gateway] = []
    @Published var isLoading: Bool = true
    let client = Database.shared

    func getAllCategories() async {
        let fetchedCategories = await client.getAllCategories()
        
        DispatchQueue.main.async {
            // Map fetched categories to SelectableCategory, with initial isSelected set to false
            self.categories = fetchedCategories.map { category in
                SelectableCategory(category: category, isSelected: false)
            }
            self.isLoading = false
        }
    }
    
    func getAllGateways() async {
        let fetchedGateways = await client.getAllGateways()
        
        DispatchQueue.main.async {
            self.gateways = fetchedGateways
        }
    }
    
    // Function to toggle selection for a specific category
    func toggleCategorySelection(_ category: SelectableCategory) {
        if let index = categories.firstIndex(where: { $0.id == category.id }) {
            categories[index].isSelected.toggle()
        }
    }
    
    // Computed property to get selected categories
    var selectedCategories: [Category] {
        categories.filter { $0.isSelected }.map { $0.category }
    }
}

struct CheeseCategoryPreferencesSelectionView: View {
    @State private var opacity: Double = 0.0
    @StateObject var viewModel = CheeseCategoryPreferencesSelectionViewModel()

    var body: some View {
        NavigationView{
            let columns: [GridItem] = [
                GridItem(.fixed(110)),
                GridItem(.fixed(110)),
                GridItem(.fixed(110))
            ]
            
            ZStack{
                CustomColors.background
                    .edgesIgnoringSafeArea(.all)
                    VStack{
                        Text("Choose your preferred cheese types")
                            .font(.custom(AppConfig.fontName, size: 20))
                            .foregroundColor(CustomColors.textColor)
                            .fontWeight(.bold)
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(viewModel.categories) { category in
                                Button(action: {
                                    viewModel.toggleCategorySelection(category)
                                    print(viewModel.categories)
                                }){
                                    Text(category.category.category)
                                        .font(.custom(AppConfig.fontName, size: 14))
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .padding()
                                        .foregroundColor(category.isSelected ? .white : CustomColors.textColor)
                                }
                                .background(category.isSelected ? Color.black.opacity(0.25) : Color.clear)
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
                        .foregroundColor(CustomColors.textColor)
                        
                        Spacer()

                        NavigationLink(destination: NotesPreferencesView()){
                            Text("Next")        .frame(maxWidth: .infinity)
                                .font(.custom(AppConfig.fontName, size: 18))
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(CustomColors.tan1)
                                .foregroundColor(CustomColors.textColor)
                        }                .cornerRadius(16)

                    }
                    .frame(maxHeight: .infinity)

                    .padding()
          
         
                
            }
            .task {
                await viewModel.getAllCategories()
                await viewModel.getAllGateways()
                viewModel.isLoading = false
            }
        }
        .tint(CustomColors.textColor)
    }
}

#Preview {
    CheeseCategoryPreferencesSelectionView()
}
