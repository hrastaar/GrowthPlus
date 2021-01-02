//
//  StockListView.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 1/1/21.
//

import SwiftUI

struct StockListView: View {
    var stock: StockPageData
    @ObservedObject var colorManager = CustomColors.shared
    
    var body: some View {
        NavigationLink(destination: StockPageView(ticker: stock.ticker)) {
            VStack {
                Text(stock.ticker)
                    .fontWeight(.semibold)
                    .minimumScaleFactor(0.001)
                    .lineLimit(2)
                Spacer()
                Text(String(format: "%.2f%%", stock.percentChange * 100.000))
                    .fontWeight(.bold)
                Spacer()
                Text(stock.companyName)
                    .minimumScaleFactor(0.001)
                    .font(primaryFont(size: 10))
            }
            .padding(.vertical, 10)
            .frame(width: 180, height: 100)
            .foregroundColor(colorManager.getSecondaryBackgroundTextColor())
            .background(colorManager.secondaryColor)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.purple, lineWidth: 5)
            )
            .font(Font.custom("DIN-D", size: 18.0))
            .cornerRadius(20)
            .multilineTextAlignment(.center)
        }
    }
}

struct StockListView_Previews: PreviewProvider {
    static var previews: some View {
        StockListView(stock: StockPageData(companyName: "Apple Inc.", ticker: "AAPL", currentPrice: 0.00, percentChange: 0.0148, dailyChange: 0.00, volume: 10000000, avgVolume: 10000000, latestTime: "", open: 0.0, low: 0.0, high: 0.0, yearLow: 0.0, yearHigh: 0.0, primaryExchange: "NASDAQ", marketCap: 0, peRatio: 0))
    }
}
