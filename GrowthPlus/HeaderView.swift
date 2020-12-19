//
//  HeaderView.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/12/20.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Welcome to GrowthPlus")
                    .font(Font.custom("DIN-D", size: 18.0))
                    .foregroundColor((Color(.systemGray3)))
            }
            Spacer()
            Image("playstore")
                .resizable()
                .frame(width: 50, height: 50)
                .cornerRadius(10)
        }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}
