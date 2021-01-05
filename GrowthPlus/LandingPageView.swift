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
    @ObservedObject var wallet = Portfolio.shared
    @ObservedObject var customColors = CustomColors.shared

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
                        PerformanceView()
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
    @ObservedObject var wallet = Portfolio.shared
    static var previews: some View {
        LandingPageView()
    }
}
