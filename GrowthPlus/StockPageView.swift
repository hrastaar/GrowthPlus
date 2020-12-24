//
//  StockPageView.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/15/20.
//

import SwiftUI

struct StockPageView: View {
    let ticker: String
    @ObservedObject var wallet: Portfolio = Portfolio.shared
    @ObservedObject var StockSearch: SearchQuery = SearchQuery.shared
    
    @State var sharesToBuy: String = ""
    @State var showInputTypeAlert: Bool = false
    @State var presentSuccessAlert: Bool = false
    @State private var showOrderConfirmationConfetti: Bool = false
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ScrollView {
            VStack {
                
                StockHeaderView
                Divider()
                PurchaseStockView
                Divider()
                StatisticsView
                NewsSectionView
            } // end of VStack
        }.onAppear {
            self.StockSearch.fetchStockData(ticker: ticker)
            self.StockSearch.fetchNewsArticles(ticker: ticker)
        }.onTapGesture {
            self.hideKeyboard()
        }
        .padding()
    }
    
    // Stock Heading: Ticker, Company Name, Price, Daily Change
    var StockHeaderView: some View {
        VStack {
            HStack(spacing: 20) {
                Text(StockSearch.stockPageData.ticker)
                    .font(Font.custom("DIN-D", size: 18.0))
                    .fontWeight(.medium)
                Spacer()
            }
            HStack(spacing: 20) {
                Text(StockSearch.stockPageData.companyName)
                    .font(Font.custom("DIN-D", size: 24.0))
                    .fontWeight(.semibold)
                Spacer()
            }
            Spacer(minLength: 15)
            HStack(spacing: 20) {
                Text(String(format: "$%.2f", StockSearch.stockPageData.currentPrice))
                    .font(Font.custom("DIN-D", size: 24.0))
                    .fontWeight(.semibold)
                Spacer()
            }
            HStack(spacing: 20) {
                Text(DollarString(value: StockSearch.stockPageData.dailyChange) + String(format: "(%.2f%%)", StockSearch.stockPageData.percentChange*100))
                    .font(Font.custom("DIN-D", size: 20.0))
                    .foregroundColor(profitLossColor(inputDouble: StockSearch.stockPageData.dailyChange))
                    .fontWeight(.semibold)
                Spacer()
            }
        }
    }
    
    var PurchaseStockView: some View {
        // Purchase Section
        VStack {
            Text("Buy \(ticker)")
                .font(Font.custom("DIN-D", size: 22.0))
                .fontWeight(.medium)

            Spacer(minLength: 22.5)
            // Number of Shares
            HStack {
                Text("Number of Shares")
                    .font(Font.custom("DIN-D", size: 18.0))
                Spacer()
                TextField("0", text: $sharesToBuy)
                    .multilineTextAlignment(.trailing)
                    .textContentType(.creditCardNumber)
                    .font(Font.custom("DIN-D", size: 18.0))
            }
            Divider()
            // Market Price
            HStack {
                Text("Market Price")
                    .font(Font.custom("DIN-D", size: 18.0))
                    .fontWeight(.medium)
                Spacer()
                Text(DollarString(value: StockSearch.stockPageData.currentPrice))
                    .font(Font.custom("DIN-D", size: 18.0))
                    .fontWeight(.medium)
            }
            
            Divider()
            // Purchase Estimated Cost
            HStack {
                Text("Estimated Cost")
                    .font(Font.custom("DIN-D", size: 18.0))
                    .fontWeight(.medium)
                Spacer()
                Text(DollarString(value: Double(Int(sharesToBuy) ?? 0) * StockSearch.stockPageData.currentPrice))
                    .font(Font.custom("DIN-D", size: 18.0))
                    .fontWeight(.medium)
            }
            Divider()
            Button(action: {
                if let shares = Int(sharesToBuy) {
                    self.presentSuccessAlert.toggle()
                    self.wallet.buyShare(ticker: ticker, shares: shares, salePrice: StockSearch.stockPageData.currentPrice)
                } else {
                    showInputTypeAlert.toggle()
                }
            }, label: {
                Text("Purchase")
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(CustomColors.shared.primaryColor))
                    .frame(minWidth: 200)
                    .foregroundColor(.white)
                    .font(Font.custom("DIN-D", size: 22.0))
            }).buttonStyle(PlainButtonStyle())
            .alert(isPresented: $showInputTypeAlert, content: {
                Alert(title:
                        Text("Invalid Number of Shares")
                            .font(Font.custom("DIN-D", size: 24.0)),
                      message:
                        Text("Please check that your input for number of shares to sell is a valid whole number")
                            .font(Font.custom("DIN-D", size: 18.0)),
                      dismissButton:
                        .default(
                            Text("Dismiss")
                                .font(Font.custom("DIN-D", size: 22.0))
                        )
                )
            }) // end of alert
            .alert(isPresented: $presentSuccessAlert, content: {
                Alert(title:
                        Text("Congrats!")
                            .font(Font.custom("DIN-D", size: 24.0)),
                      message: Text("You have successfully purchased \(sharesToBuy) shares of \(ticker)!"),
                      dismissButton:
                        .default(
                            Text("Dismiss")
                                .font(Font.custom("DIN-D", size: 22.0))
                        )
                )
            }) // end of alert
        }
    }
    
    var StatisticsView: some View {
        VStack {
            // Stats Section
            HStack {
                Text("Stats")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
            }
            HStack {
                VStack(spacing: 15) {
                    HStack {
                        Text("Open")
                            .font(Font.custom("DIN-D", size: 16.0))
                        Spacer()
                        Text(DollarString(value: StockSearch.stockPageData.open))
                            .font(Font.custom("DIN-D", size: 16.0))
                    }
                    Divider()
                    HStack {
                        Text("High")
                            .font(Font.custom("DIN-D", size: 16.0))
                        Spacer()
                        Text(DollarString(value: StockSearch.stockPageData.high))
                            .font(Font.custom("DIN-D", size: 16.0))
                    }
                    Divider()
                    HStack {
                        Text("Low")
                            .font(Font.custom("DIN-D", size: 16.0))
                        Spacer()
                        Text(DollarString(value: StockSearch.stockPageData.low))
                            .font(Font.custom("DIN-D", size: 16.0))
                    }
                    Divider()
                    HStack {
                        Text("52 Week High")
                            .font(Font.custom("DIN-D", size: 16.0))
                        Spacer()
                        Text(DollarString(value: StockSearch.stockPageData.yearHigh))
                            .font(Font.custom("DIN-D", size: 16.0))
                    }
                    Divider()
                    HStack {
                        Text("52 Week Low")
                            .font(Font.custom("DIN-D", size: 16.0))
                        Spacer()
                        Text(DollarString(value: StockSearch.stockPageData.yearLow))
                            .font(Font.custom("DIN-D", size: 16.0))
                    }
                    Divider()
                }
                Spacer()
                HStack {
                    Divider()
                }
                Spacer()
                VStack(spacing: 15) {
                    HStack {
                        Text("Volume")
                            .font(Font.custom("DIN-D", size: 16.0))
                        Spacer()
                        Text(String(StockSearch.stockPageData.volume))
                            .font(Font.custom("DIN-D", size: 16.0))
                    }
                    Divider()
                    HStack {
                        Text("Avg Vol")
                            .font(Font.custom("DIN-D", size: 16.0))
                        Spacer()
                        Text(String(StockSearch.stockPageData.avgVolume))
                            .font(Font.custom("DIN-D", size: 16.0))
                    }
                    Divider()
                    HStack {
                        Text("Mkt Cap")
                            .font(Font.custom("DIN-D", size: 16.0))
                        Spacer()
                        Text(String(StockSearch.stockPageData.marketCap))
                            .font(Font.custom("DIN-D", size: 12.0))
                    }
                    Divider()
                    HStack {
                        Text("P/E Ratio")
                            .font(Font.custom("DIN-D", size: 16.0))
                        Spacer()
                        Text(String(format: "%.2f", StockSearch.stockPageData.peRatio))
                            .font(Font.custom("DIN-D", size: 16.0))
                    }
                    Divider()
                    HStack {
                        Text("Exchange")
                            .font(Font.custom("DIN-D", size: 16.0))
                        Spacer()
                        Text(StockSearch.stockPageData.primaryExchange)
                            .font(Font.custom("DIN-D", size: 12.0))
                    }
                    Divider()
                }
            } // End of HStack for Stats
            .font(.subheadline)
        }
    }
    
    var NewsSectionView: some View {
        VStack(spacing: 20) {
            HStack {
                Text("News")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 25) {
                    ForEach(StockSearch.stockNewsArticles.indices, id: \.self) { index in
                        NewsArticleView(newsArticle: StockSearch.stockNewsArticles[index])
                            .padding(5)
                    }
                }
            }
        }
    }
    
}

struct StockPageView_Previews: PreviewProvider {
    static var previews: some View {
        StockPageView(ticker: "AAPL")
    }
}
