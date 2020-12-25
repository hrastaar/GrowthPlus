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
    @ObservedObject var wallet: Portfolio
    @ObservedObject var customColors = CustomColors.shared
    @State var firstVisit: Bool = false
    init() {
        wallet = Portfolio.shared
        firstVisit = wallet.firstVisit
        if firstVisit {
            print("First visit")
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HeaderView()
                    InvestmentHeaderView()
                    MenuUtilitiesView()
                    if wallet.loadedHoldings {
                        if wallet.portfolioCards.count > 0 && wallet.presentStocks {
                            PortfolioListView()
                            Divider()
                            PerformanceView()
                            Divider()
                            SellView()
                            Spacer()
                        }
                    }
                }.padding(25)
            }.onTapGesture {
                self.hideKeyboard()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    @ObservedObject var wallet = Portfolio.shared
    static var previews: some View {
        LandingPageView()
    }
}
