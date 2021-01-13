//
//  ContentView.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/12/20.
//

import Alamofire
import RealmSwift
import SwiftUI
import SwiftyJSON

struct LandingPageView: View {
    @ObservedObject var wallet = PortfolioManager.shared

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HeaderView()
                    InvestmentHeaderView()
                    MenuUtilitiesView()
                    if !wallet.portfolioCards.isEmpty {
                        PortfolioListView()
                        Divider()
                        StockPerformanceView()
                        Divider()
                        SellView()
                        Spacer()
                    }
                }.padding(25)
            }.onTapGesture {
                self.hideKeyboard()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    @ObservedObject var wallet = PortfolioManager.shared
    static var previews: some View {
        LandingPageView()
    }
}
