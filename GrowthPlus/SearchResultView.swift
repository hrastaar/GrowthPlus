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
    @ObservedObject var stockData = StockPageData()
    var body: some View {
        NavigationLink(destination: StockPageView(ticker: searchResult.ticker)) {
            VStack(spacing: 8) {
                HStack(spacing: 15) {
                    Text(searchResult.companyName)
                        .font(Font.custom("AppleColorEmoji", size: 16.0))
                        .fontWeight(.semibold)
                        .lineLimit(2)
                        .foregroundColor(CustomColors.shared.primaryColor)
                    Spacer()
                }
                HStack(spacing: 15) {
                    Text(searchResult.ticker)
                        .font(Font.custom("AppleColorEmoji", size: 13.0))
                        .minimumScaleFactor(0.001)
                        .lineLimit(1)
                        .foregroundColor(CustomColors.shared.primaryColor)
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
