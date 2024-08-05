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
                    Spacer()
                }
                .padding()
            }
            .foregroundColor(CustomColors.textColor)
        }
    }
}

#Preview {
    MyCheesesView()
}
