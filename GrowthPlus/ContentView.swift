//
//  ContentView.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/12/20.
//

import SwiftUI
import RealmSwift
import SwiftyJSON
import Alamofire

struct ContentView: View {
    @ObservedObject var wallet: Portfolio
    @ObservedObject var customColors: CustomColors = CustomColors.shared
    @State var firstVisit: Bool = false
    init() {
        wallet = Portfolio.shared
        self.firstVisit = wallet.firstVisit
        if self.firstVisit {
            print("First visit")
        }
    }
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HeaderView()
                    InvestmentHeaderView()
                    HStack {
                        NavigationLink(
                            destination: SettingsView(),
                            label: {
                                Image(systemName: "gear")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(customColors.primaryColor)
                                    .cornerRadius(10)
                            }
                        )
                        Spacer()
                        NavigationLink(
                            destination: SearchStockView(),
                            label: {
                                Image(systemName: "plus")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(customColors.primaryColor)
                                    .cornerRadius(10)
                            }
                        )
                    }
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
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    @ObservedObject var wallet = Portfolio.shared
    static var previews: some View {
        ContentView()
    }
}
