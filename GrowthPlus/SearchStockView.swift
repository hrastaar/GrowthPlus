//
//  NewPositionView.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/13/20.
//

import SwiftUI

struct SearchStockView: View {
    @ObservedObject var StockSearch = FinancialAPIConnection.shared
    
    @State var ticker: String = ""
    @State var searchQuery: String = ""
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text("Search for a Stock")
                        .font(primaryFont(size: 24))
                        .minimumScaleFactor(0.001)
                        .lineLimit(1)
                    Spacer()
                }
                TextField("Search by ticker...",
                          text: $searchQuery)
                    .font(primaryFont(size: 20))
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
            } // end of VStack
            .padding(25)

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
