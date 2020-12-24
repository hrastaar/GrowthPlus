//
//  NewPositionView.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/13/20.
//

import SwiftUI

struct SearchStockView: View {
    @State var ticker: String = ""
    @ObservedObject var wallet: Portfolio = Portfolio.shared
    @ObservedObject var StockSearch = SearchQuery.shared
    @State var searchQuery: String = ""
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text("Search for a Stock")
                        .font(Font.custom("DIN-D", size: 30.0))
                        .fontWeight(.bold)
                    Spacer()
                }
                TextField("Search by ticker...",
                          text: $searchQuery)
                    .font(Font.custom("DIN-D", size: 20.0))
                    .disableAutocorrection(true)
                    .autocapitalization(.allCharacters)
                    .onChange(of: searchQuery, perform: { value in
                        searchQuery = searchQuery.uppercased()
                        StockSearch.searchTicker(ticker: value, exchange: nil)
                    })
                Spacer()
                ForEach(self.StockSearch.searchResults.indices, id: \.self) { index in
                    SearchResultView(searchResult: self.StockSearch.searchResults[index])
                    Divider()
                        .foregroundColor(.white)
                }
            }.padding(25)

        }.onTapGesture {
            self.hideKeyboard()
        }
    }
}

struct NewPositionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SearchStockView()
        }
    }
}
