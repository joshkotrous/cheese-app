//
//  MyCheesesView.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/4/24.
//

import SwiftUI

struct MyCheesesView: View {
    var body: some View {
        VStack(spacing: 0){

            ZStack{
                CustomColors.background
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    HStack{
                            Text("+")
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
                            // Action to perform when the button is tapped
                            print("Button tapped!")
                        }) {
                            Text("+ New Cupboard")
                                .font(.custom("IowanOldStyle-Roman", size: 16))
                                .padding(6)
                                .background(CustomColors.textColor)
                                .foregroundColor(CustomColors.background)
                                .cornerRadius(100)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                    .padding(.bottom)
                 
                    Spacer()
                }
                .frame(maxWidth: .infinity)

            }
            .foregroundColor(CustomColors.textColor)
        }
    }
}

#Preview {
    MyCheesesView()
}
