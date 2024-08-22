//
//  MyCheesesView.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/4/24.
//

import SwiftUI

struct MyCheesesView: View {
    @State public var showCupboardPopover = false
    @State public var showCheesePopover = false
    @State private var newCupboardInput: String = ""
    @AppStorage("accessToken") var accessToken: String?
    @AppStorage("userId") var userId: String?
    @AppStorage("profileId") var profileId: String?
    @State private var cupboards: [Cupboard]? 
    
    var body: some View {
        NavigationStack {
            
            VStack(spacing: 0){
                ZStack{
                    
                    CustomColors.background
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack{
                        HStack{
                            Text("My Cheeses")
                            
                        }
                        .font(.custom("IowanOldStyle-Roman", size: 24))
                        
                       
                            
                            List{
                                Section{
                                    ForEach(cupboards ?? []) { cupboard in
                                        if(cupboard.name != "Created By Me") {
                                            NavigationLink(destination: CupboardListView(cupboardId: cupboard.id!)){
                                                Text(cupboard.name ?? "")
                                                    .font(.custom("IowanOldStyle-Roman", size: 24))
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .fontWeight(.bold)
                                                
                                                
                                        
                                                
                                                
                                            }
                                            
                                            .padding()
                                        } else {
                                            NavigationLink(destination: CupboardListView(cupboardId: cupboard.id!)){
                                                Text(cupboard.name ?? "")
                                                    .font(.custom("IowanOldStyle-Roman", size: 24))
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .fontWeight(.bold)
                                                
                                                
                                        
                                                
                                                
                                            }
                                            
                                            .padding()
                                            .deleteDisabled(true)
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
                        
                        Spacer()
                        HStack{
                            Button(action: {
                                showCupboardPopover = true
                                print("Button tapped!")
                            }) {
                                Text("+ New Cupboard")
                                    .font(.custom("IowanOldStyle-Roman", size: 16))
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
                                    .font(.custom("IowanOldStyle-Roman", size: 16))
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
                NewCheesePopover()
            }
            .task {
                if(profileId != nil){
                    cupboards = await Database().getUserCupboards(profileId: profileId!)
                    
                }
            }
            
        }
        
    }
    
}

#Preview {
    MyCheesesView()
}
