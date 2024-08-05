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

    var body: some View {
        VStack(spacing: 0){
            ZStack{
                CustomColors.background
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    HStack{
                        Text("My Cheeses")
                        
                    }
                    .font(.custom("IowanOldStyle-Roman", size: 24))
                    ScrollView{
                        VStack{
                            VStack{
                                Text("Cupboard 1")
                                    .font(.custom("IowanOldStyle-Roman", size: 24))
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                Text("0 Cheeses")
                                    .font(.custom("IowanOldStyle-Roman", size: 16))

                                    .frame(maxWidth: .infinity, alignment: .leading)

                            }
                        }
                        .padding()
                        .overlay(
                                VStack {
                                    Spacer()
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundColor(CustomColors.textColor)
                                }
                            )
                        VStack{
                            VStack{
                                Text("Cupboard 2")
                                    .font(.custom("IowanOldStyle-Roman", size: 24))
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                Text("0 Cheeses")
                                    .font(.custom("IowanOldStyle-Roman", size: 16))

                                    .frame(maxWidth: .infinity, alignment: .leading)

                            }
                        }
                        .padding()
                        .overlay(
                                VStack {
                                    Spacer()
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundColor(CustomColors.textColor)
                                }
                            )
                    }
                    
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
                 
                    Spacer()
                }
                .frame(maxWidth: .infinity)

            }
            .foregroundColor(CustomColors.textColor)
        }
        .popover(isPresented: $showCupboardPopover) {
            ZStack{
                CustomColors.background
                    .ignoresSafeArea(.all)
                VStack {
                    Text("Add Cupboard")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.custom("IowanOldStyle-Roman", size: 24))
                    Spacer()

                }
                .foregroundColor(CustomColors.textColor)
                .padding()

            }
     
        }
        .popover(isPresented: $showCheesePopover) {
            ZStack{
                CustomColors.background
                    .ignoresSafeArea(.all)
                VStack {
                    Text("Add Cheese")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.custom("IowanOldStyle-Roman", size: 24))
                    Spacer()
                }
                .foregroundColor(CustomColors.textColor)
                .padding()
            }
        }
    }
}

#Preview {
    MyCheesesView()
}
