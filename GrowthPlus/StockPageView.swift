//
//  StockPageView.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/15/20.
//

import SwiftUI
import SwiftUICharts

struct StockPageView: View {
    let ticker: String
    @ObservedObject var wallet = Portfolio.shared
    @ObservedObject var financialToolConnection = FinancialAPIConnection.shared

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
                IntradayChartView
                Divider()
                PurchaseStockView
                Divider()
                StatisticsView
                NewsSectionView
            } // end of VStack
        }.onAppear {
            self.financialToolConnection.fetchStockPageData(ticker: ticker)
        }.onTapGesture {
            self.hideKeyboard()
        }
        .padding()
    }

    // Stock Heading: Ticker, Company Name, Price, Daily Change
    var StockHeaderView: some View {
        VStack {
            HStack(spacing: 20) {
                Text(financialToolConnection.stockPageData.ticker)
                    .font(Font.custom("DIN-D", size: 18.0))
                    .fontWeight(.medium)
                Spacer()
            }
            HStack(spacing: 20) {
                Text(financialToolConnection.stockPageData.companyName)
                    .font(Font.custom("DIN-D", size: 24.0))
                    .fontWeight(.semibold)
                Spacer()
            }
            Spacer(minLength: 15)
            HStack(spacing: 20) {
                Text(String(format: "$%.2f", financialToolConnection.stockPageData.currentPrice))
                    .font(Font.custom("DIN-D", size: 24.0))
                    .fontWeight(.semibold)
                Spacer()
            }
            HStack(spacing: 20) {
                Text(DollarString(value: financialToolConnection.stockPageData.dailyChange) + String(format: "(%.2f%%)", financialToolConnection.stockPageData.percentChange * 100))
                    .font(Font.custom("DIN-D", size: 20.0))
                    .foregroundColor(profitLossColor(inputDouble: financialToolConnection.stockPageData.dailyChange))
                    .fontWeight(.semibold)
                Spacer()
            }
        }
    }

    // View designated for purchasing shares of stock
    var PurchaseStockView: some View {
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
                Text(DollarString(value: financialToolConnection.stockPageData.currentPrice))
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
                Text(DollarString(value: Double(Int(sharesToBuy) ?? 0) * financialToolConnection.stockPageData.currentPrice))
                    .font(Font.custom("DIN-D", size: 18.0))
                    .fontWeight(.medium)
            }
            Divider()
            Button(action: {
                if let shares = Int(sharesToBuy) {
                    self.presentSuccessAlert.toggle()
                    self.wallet.buyShare(ticker: ticker, shares: shares, salePrice: financialToolConnection.stockPageData.currentPrice)
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
                        ))
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
                        ))
                }) // end of alert
        }
    }

    // Statistical Information View for Current Stock
    var StatisticsView: some View {
        VStack {
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
                        Text(DollarString(value: financialToolConnection.stockPageData.open))
                            .font(Font.custom("DIN-D", size: 16.0))
                    }
                    Divider()
                    HStack {
                        Text("High")
                            .font(Font.custom("DIN-D", size: 16.0))
                        Spacer()
                        Text(DollarString(value: financialToolConnection.stockPageData.high))
                            .font(Font.custom("DIN-D", size: 16.0))
                    }
                    Divider()
                    HStack {
                        Text("Low")
                            .font(Font.custom("DIN-D", size: 16.0))
                        Spacer()
                        Text(DollarString(value: financialToolConnection.stockPageData.low))
                            .font(Font.custom("DIN-D", size: 16.0))
                    }
                    Divider()
                    HStack {
                        Text("52 Week High")
                            .font(Font.custom("DIN-D", size: 16.0))
                        Spacer()
                        Text(DollarString(value: financialToolConnection.stockPageData.yearHigh))
                            .font(Font.custom("DIN-D", size: 16.0))
                    }
                    Divider()
                    HStack {
                        Text("52 Week Low")
                            .font(Font.custom("DIN-D", size: 16.0))
                        Spacer()
                        Text(DollarString(value: financialToolConnection.stockPageData.yearLow))
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
                        Text(String(financialToolConnection.stockPageData.volume))
                            .font(Font.custom("DIN-D", size: 16.0))
                    }
                    Divider()
                    HStack {
                        Text("Avg Vol")
                            .font(Font.custom("DIN-D", size: 16.0))
                        Spacer()
                        Text(String(financialToolConnection.stockPageData.avgVolume))
                            .font(Font.custom("DIN-D", size: 16.0))
                    }
                    Divider()
                    HStack {
                        Text("Mkt Cap")
                            .font(Font.custom("DIN-D", size: 16.0))
                        Spacer()
                        Text(String(financialToolConnection.stockPageData.marketCap))
                            .font(Font.custom("DIN-D", size: 12.0))
                    }
                    Divider()
                    HStack {
                        Text("P/E Ratio")
                            .font(Font.custom("DIN-D", size: 16.0))
                        Spacer()
                        Text(String(format: "%.2f", financialToolConnection.stockPageData.peRatio))
                            .font(Font.custom("DIN-D", size: 16.0))
                    }
                    Divider()
                    HStack {
                        Text("Exchange")
                            .font(Font.custom("DIN-D", size: 16.0))
                        Spacer()
                        Text(financialToolConnection.stockPageData.primaryExchange)
                            .font(Font.custom("DIN-D", size: 12.0))
                    }
                    Divider()
                }
            }
            .font(.subheadline)
        }
    }

    // News Section View that contains recent news articles on stock
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
                    ForEach(financialToolConnection.stockNewsArticles.indices, id: \.self) { index in
                        NewsArticleView(newsArticle: financialToolConnection.stockNewsArticles[index])
                            .padding(5)
                    }
                }
            }
        }
    }

    var IntradayChartView: some View {
        MultiLineChartView(data: [(self.financialToolConnection.stockChartPoints.map { $0.avgPrice }, GradientColor(start: CustomColors.shared.primaryColor, end: CustomColors.shared.primaryColor))], title: "Intraday Activity", form: ChartForm.large, rateValue: Int(financialToolConnection.stockPageData.percentChange * 100), dropShadow: false)
            .font(Font.custom("DIN-D", size: 18.0))
    }
}

struct StockPageView_Previews: PreviewProvider {
    static var previews: some View {
        StockPageView(ticker: "AAPL")
    }
}
