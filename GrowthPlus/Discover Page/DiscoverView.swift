//
//  DiscoverView.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/30/20.
//

import SwiftUI

struct DiscoverView: View {
    @ObservedObject var financialToolConnection = FinancialAPIConnection.shared
    @ObservedObject var colorManager = CustomColors.shared
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ScrollView {
            VStack {
                Section {
                    VStack(spacing: 10) {
                        LottieView(fileName: "education", backgroundColor: colorScheme == .dark ? Color.black : Color.white)
                            .frame(height: 250)
                            .cornerRadius(12)
                        
                        Text("Welcome to the Discover Page, where you can see how the major sectors, indexes, and industries are currently performing.")
                            .font(primaryFont(size: 12))
                        
                        Section {
                            HStack {
                                Text("Today's Sector Performances")
                                    .font(primaryFont(size: 20))
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(financialToolConnection.sectorPerformances.indices, id: \.self) { index in
                                            SectorView(sector: financialToolConnection.sectorPerformances[index])
                                                .padding(7.5)
                                    }
                                }
                            } // ScrollView
                            
                            HStack {
                                Text("Today's Most Active Stocks")
                                    .font(primaryFont(size: 20))
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(financialToolConnection.mostActiveStocks.indices, id: \.self) { index in
                                        StockListView(stock: financialToolConnection.mostActiveStocks[index])
                                            .padding(7.5)
                                    }
                                }
                            } // ScrollView
                            
                            HStack {
                                Text("Today's Best Performing Stocks")
                                    .font(primaryFont(size: 20))
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(financialToolConnection.todayGainersStocks.indices, id: \.self) { index in
                                        StockListView(stock: financialToolConnection.todayGainersStocks[index])
                                            .padding(7.5)
                                    }
                                }
                            } // ScrollView
                            
                            HStack {
                                Text("Today's Worst Performing Stocks")
                                    .font(primaryFont(size: 20))
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(financialToolConnection.todayLosersStocks.indices, id: \.self) { index in
                                        StockListView(stock: financialToolConnection.todayLosersStocks[index])
                                            .padding(7.5)
                                    }
                                }
                            } // ScrollView
                            
                            HStack {
                                Text("News About Your Stocks")
                                    .font(primaryFont(size: 20))
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(financialToolConnection.holdingsNewsArticles.indices, id: \.self) { index in
                                        NewsArticleView(newsArticle: financialToolConnection.holdingsNewsArticles[index])
                                    }
                                }
                            }
                        }
                    } // VStack
                }.padding()
            }
        }.navigationTitle("Discover")
        .onAppear {
            self.financialToolConnection.getDiscoveryPageData()
        }
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}
