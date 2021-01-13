//
//  DiscoverView.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/30/20.
//

import SwiftUI

struct DiscoverView: View {
    @ObservedObject var financialToolConnection = FinancialAPIConnection.shared
    @ObservedObject var colorManager = AppColorManager.shared
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
                            if !financialToolConnection.dailySectorPerformancesList.isEmpty {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 15) {
                                        ForEach(financialToolConnection.dailySectorPerformancesList.indices, id: \.self) { index in
                                            SectorView(sector: financialToolConnection.dailySectorPerformancesList[index])
                                                .padding(7.5)
                                        }
                                    }
                                } // ScrollView
                            } else {
                                Text("Unable to fetch sector performances from our data provider")
                                    .font(primaryFont(size: 12))
                                    .multilineTextAlignment(.center)
                            }

                            HStack {
                                Text("Today's Most Active Stocks")
                                    .font(primaryFont(size: 20))
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(financialToolConnection.dailyMostActiveStocksList.indices, id: \.self) { index in
                                        StockListView(stock: financialToolConnection.dailyMostActiveStocksList[index])
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
                            if !financialToolConnection.dailyBestPerformingStocksList.isEmpty {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 15) {
                                        ForEach(financialToolConnection.dailyBestPerformingStocksList.indices, id: \.self) { index in
                                            StockListView(stock: financialToolConnection.dailyBestPerformingStocksList[index])
                                                .padding(7.5)
                                        }
                                    }
                                } // ScrollView
                            } else {
                                Text("Unable to fetch today's best performing stocks from our data provider")
                                    .font(primaryFont(size: 12))
                                    .multilineTextAlignment(.center)
                            }

                            HStack {
                                Text("Today's Worst Performing Stocks")
                                    .font(primaryFont(size: 20))
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            if !financialToolConnection.dailyWorstPerformingStocksList.isEmpty {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 15) {
                                        ForEach(financialToolConnection.dailyWorstPerformingStocksList.indices, id: \.self) { index in
                                            StockListView(stock: financialToolConnection.dailyWorstPerformingStocksList[index])
                                                .padding(7.5)
                                        }
                                    }
                                } // ScrollView
                            } else {
                                Text("Unable to fetch today's worst performing stocks from our data provider")
                                    .font(primaryFont(size: 12))
                                    .multilineTextAlignment(.center)
                            }

                            HStack {
                                Text("News About Your Stocks")
                                    .font(primaryFont(size: 20))
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(financialToolConnection.portfolioHoldingsNewsArticlesList.indices, id: \.self) { index in
                                        NewsArticleView(newsArticle: financialToolConnection.portfolioHoldingsNewsArticlesList[index])
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
