//
//  StockListView.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 1/1/21.
//

import SwiftUI

struct StockListView: View {
    var stock: StockListData
    @ObservedObject var colorManager = CustomColors.shared
    
    var body: some View {
        NavigationLink(destination: StockPageView(ticker: stock.ticker)) {
            VStack {
                Text(stock.ticker)
                    .fontWeight(.semibold)
                    .minimumScaleFactor(0.001)
                    .lineLimit(2)
                Spacer()
                Text(stock.displayPercentChange)
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
        StockListView(stock: StockListData(ticker: "AAPL", companyName: "Apple Inc.", percentChange: 0.013, dailyChange: 1.32))
    }
}
