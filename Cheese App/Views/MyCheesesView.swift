//
//  MyCheesesView.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/4/24.
//

import SwiftUI

class MyCheesesViewModel: ObservableObject {
    @Published var isLoading: Bool = true
    
}

struct MyCheesesView: View {
    @State public var showCupboardPopover = false
    @State public var showCheesePopover = false
    @State private var newCupboardInput: String = ""
    @AppStorage("accessToken") var accessToken: String?
    @AppStorage("userId") var userId: String?
    @AppStorage("profileId") var profileId: String?
    @State private var cupboards: [Cupboard]?
    @Binding var selectedTab: Tab
    @StateObject var viewModel = MyCheesesViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0){
                ZStack{
                    
                    CustomColors.background
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack{
                        Text("My Cheeses")
                            .font(.custom(AppConfig.fontName, size: 24))
                            .foregroundColor(CustomColors.textColor)
                        if(viewModel.isLoading){
                            VStack{
                                ProgressView() // Spinner shown when loading
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .scaleEffect(1.5) // Make the spinner larger if needed
                            }.frame(maxWidth: .infinity, maxHeight: .infinity).background(CustomColors.background)
                        } else {
                            List{
                                Section{
                                    ForEach(cupboards ?? []) { cupboard in
                                        if  !AppConfig.defaultCupboards.contains(cupboard.name ?? "") {
                                            NavigationLink(destination: CupboardListView(cupboardId: cupboard.id!, selectedTab: $selectedTab, cupboardName: cupboard.name!)) {
                                                Text(cupboard.name ?? "")
                                                    .font(.custom(AppConfig.fontName, size: 24))
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .fontWeight(.bold)
                                            }
                                            .padding()
                                        } else {
                                            NavigationLink(destination: CupboardListView(cupboardId: cupboard.id!, selectedTab: $selectedTab, cupboardName: cupboard.name!)) {
                                                Text(cupboard.name ?? "")
                                                    .font(.custom(AppConfig.fontName, size: 24))
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .fontWeight(.bold)
                                            }
                                            .deleteDisabled(true)
                                            .padding()
                                        }
                                    }
                                    .onDelete(perform: { indexSet in
                                        let idsToDelete = indexSet.map { cupboards![$0].id }
                                        if (idsToDelete.count == 0){
                                            return
                                        }
                                        Task{
                                            await Database().deleteCupboard(cupboardId: idsToDelete[0]!)
                                            
                                            
                                        }
                                        print("deleted")
                                    })
                                    
                                    .listRowBackground(CustomColors.background)
                                    
                                    
                                }
                                
                            }
                            .scrollContentBackground(.hidden)
                            .listStyle(PlainListStyle())
                        }
                        Spacer()
                        HStack{
                            Button(action: {
                                showCupboardPopover = true
                                print("Button tapped!")
                            }) {
                                Text("+ New Cupboard")
                                    .font(.custom(AppConfig.fontName, size: 16))
                                    .padding(6)
                                    .background(CustomColors.tan1)
                                    .foregroundColor(CustomColors.textColor)
                                    .cornerRadius(100)
                            }
                            
                            Button(action: {
                                showCheesePopover = true
                                print("Button tapped!")
                            }) {
                                Text("+ Add Cheese")
                                    .font(.custom(AppConfig.fontName, size: 16))
                                    .padding(6)
                                    .background(CustomColors.tan1)
                                    .foregroundColor(CustomColors.textColor)
                                    .cornerRadius(100)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.leading)
                        .padding(.bottom)
                        
                    }
                    .frame(maxWidth: .infinity)
                    
                }
                .foregroundColor(CustomColors.textColor)
            }
            .popover(isPresented: $showCupboardPopover) {
                NewCupboardPopover(showCupboardPopover: $showCupboardPopover, cupboards: $cupboards)
                
            }
            .popover(isPresented: $showCheesePopover) {
                NewCheesePopover(showNewCheesePopover: $showCheesePopover, cupboardId: "", cupboardName: "")
            }
            .task {
                if(profileId != nil){
                    cupboards = await Database().getUserCupboards(profileId: profileId!)
                    
                }
                viewModel.isLoading = false
            }
        }
    }
}

struct MyCheesesViewPreview: View {
    @State var selectedTab = Tab.home
    var body: some View {
        MyCheesesView(selectedTab: $selectedTab)
    }
}

#Preview {
    MyCheesesViewPreview()
}
