//
//  StockCardView.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/12/20.
//

import SwiftUI

struct StockCardView: View {
    @ObservedObject var card: StockDataModel
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
        .cornerRadius(15)
        .frame(width: 110, height: 150)
    }
}

struct StockView_Previews: PreviewProvider {
    static var previews: some View {
        StockCardView(card: StockDataModel(companyName: "Apple Inc.", ticker: "AAPL", avgCost: 132.00, shares: 10, currentPrice: 131.44, percentChange: 0.002, dailyChange: 0.10, volume: 1_000_000_000, avgVolume: 1_000_000_000, imageName: "stock"))
    }
}
