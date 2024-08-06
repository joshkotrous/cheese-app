//
//  DiscoverView.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/4/24.
//

import SwiftUI

struct DiscoverView: View {
    var body: some View {
        VStack(spacing: 0){
            SearchBar()
            ZStack{
                CustomColors.background
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    Text("Explore Categories")
                        .font(.custom("IowanOldStyle-Roman", size: 28))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                }
                .padding()
            }
            .foregroundColor(CustomColors.textColor)
        }
    }
}

#Preview {
    DiscoverView()
}
