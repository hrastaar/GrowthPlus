//
//  StockView.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/12/20.
//

import SwiftUI

struct StockView: View {
    let card: Stock
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image(card.imageName)
                    .resizable()
                    .frame(width: 20, height: 20)
            }
            .padding(.horizontal, 10)
            .padding(.top, 5)
            Spacer()
            Text(card.ticker)
                .foregroundColor(card.textColor)
                .font(Font.custom("DIN-D", size: 24.0))
                .fontWeight(.semibold)
                .fixedSize()
                .padding()
            Text(DollarString(value: card.currentPrice))
                .foregroundColor(card.textColor)
                .fontWeight(.bold)
                .font(Font.custom("DIN-D", size: 18.0))
            Text("\(card.shares) Shares")
                .foregroundColor(card.textColor)
                .font(Font.custom("DIN-D", size: 16.0))
        }
        .padding(.vertical, 10)
        .background(card.backgroundColor)
        .cornerRadius(12)
        .frame(width: 110, height: 150)
    }
}

struct StockView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioListView()
    }
}
