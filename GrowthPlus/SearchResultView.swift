//
//  SearchResultView.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/15/20.
//

import SwiftUI

struct SearchResultView: View {
    let searchResult: SearchResult
    @ObservedObject var StockSearch = FinancialAPIConnection.shared
    @ObservedObject var colorManager = CustomColors.shared
    @ObservedObject var stockData = StockPageData()

    var body: some View {
        NavigationLink(destination: StockPageView(ticker: searchResult.ticker)) {
            VStack(spacing: 8) {
                HStack(spacing: 15) {
                    Text(searchResult.companyName)
                        .font(primaryFont(size: 16))
                        .fontWeight(.semibold)
                        .lineLimit(2)
                        .foregroundColor(colorManager.primaryColor)
                    Spacer()
                }
                HStack(spacing: 15) {
                    Text(searchResult.ticker)
                        .font(primaryFont(size: 13))
                        .minimumScaleFactor(0.001)
                        .lineLimit(1)
                        .foregroundColor(colorManager.primaryColor)
                    Spacer()
                }
            }
        }
    }
}

struct SearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultView(searchResult: SearchResult(ticker: "AAPL", companyName: "Apple", region: "US"))
    }
}
