//
//  HomeView.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/4/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: 0){
            SearchBar()
            ZStack{
                ScrollView {
                    VStack{
                        Text("Trending")
                            .font(.custom("IowanOldStyle-Roman", size: 24))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        VStack{
                            VStack{
                                CustomColors.tan1
                                
                            }
                            .frame(height: 200)
                            .frame(width: .infinity)
                            .cornerRadius(12.0)
                            .overlay( /// apply a rounded border
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(CustomColors.textColor, lineWidth: 1)
                            )

                            
                            
                        }
                        Text("New")
                            .font(.custom("IowanOldStyle-Roman", size: 24))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        VStack{
                            VStack{
                                CustomColors.tan1
                                
                            }
                            .frame(height: 200)
                            .frame(width: .infinity)
                            .cornerRadius(12.0)
                            .overlay( /// apply a rounded border
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(CustomColors.textColor, lineWidth: 1)
                            )
                            VStack{
                                CustomColors.tan1
                                
                            }
                            .frame(height: 200)
                            .frame(width: .infinity)
                            .cornerRadius(12.0)
                            .overlay( /// apply a rounded border
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(CustomColors.textColor, lineWidth: 1)
                            )
                            VStack{
                                CustomColors.tan1
                                
                            }
                            .frame(height: 200)
                            .frame(width: .infinity)
                            .cornerRadius(12.0)
                            .overlay( /// apply a rounded border
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(CustomColors.textColor, lineWidth: 1)
                            )
                            VStack{
                                CustomColors.tan1
                                
                            }
                            .frame(height: 200)
                            .frame(width: .infinity)
                            .cornerRadius(12.0)
                            .overlay( /// apply a rounded border
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(CustomColors.textColor, lineWidth: 1)
                            )
                            
                            
                        }
                    }
                    .padding()
                }
                .background(CustomColors.background)

            }
            .foregroundColor(CustomColors.textColor)
        }
        }

}

#Preview {
    AppView()
}
