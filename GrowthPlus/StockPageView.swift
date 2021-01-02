//
//  StockPageView.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/15/20.
//

import SwiftUI
import SwiftUICharts
import SkeletonUI
import PopupView

struct StockPageView: View {
    let ticker: String
    @ObservedObject var wallet = Portfolio.shared
    @ObservedObject var financialConnection = FinancialAPIConnection.shared
    @ObservedObject var colorManager = CustomColors.shared
    
    @State var sharesToBuy: String = ""
    @State var showInputTypeAlert: Bool = false
    @State var presentSuccessAlert: Bool = false
    @State var successMessage = ""
    @State var showOrderConfirmationConfetti: Bool = false
    @State var showCompanyProfilePopoverView: Bool = false
    
    var body: some View {
        ZStack {
            if showCompanyProfilePopoverView {
                CompanyInfoPopoverView
                    .zIndex(1.0)
            }
            ScrollView {
                VStack {
                    StockHeaderView
                    IntradayChartView
                        .padding(5)
                    Divider()
                    PurchaseStockView
                    Divider()
                    StatisticsView
                    NewsSectionView
                } // end of VStack
            }.onAppear {
                self.financialConnection.fetchStockPageData(ticker: ticker)
            }.onTapGesture {
                self.hideKeyboard()
            }
            .padding()
            .zIndex(0.9)
        }
        .popup(isPresented: $presentSuccessAlert) {
            ShowSalePopupView(popupResult: .success, message: self.successMessage)
                .opacity(self.presentSuccessAlert ? 1.0 : 0.0)
        }
        .popup(isPresented: $showInputTypeAlert) {
            ShowSalePopupView(popupResult: .inputTypeError, message: "Invalid number of shares to sell. Please check your input.")
                .opacity(self.showInputTypeAlert ? 1.0 : 0.0)
        }
    }

    // Stock Heading: Ticker, Company Name, Price, Daily Change
    var StockHeaderView: some View {
        VStack {
            HStack(spacing: 20) {
                Text(financialConnection.stockPageData.ticker)
                    .font(primaryFont(size: 18))
                    .fontWeight(.medium)
                    .skeleton(with: !(financialConnection.stockPageData.success ?? false))
                    .animation(type: .pulse())

                Spacer()
            }
            HStack(spacing: 20) {
                Text(financialConnection.stockPageData.companyName)
                    .font(primaryFont(size: 24))
                    .fontWeight(.semibold)
                    .skeleton(with: !(financialConnection.stockPageData.success ?? false))
                    .animation(type: .pulse())

                Button(action: {
                    self.showCompanyProfilePopoverView.toggle()
                }, label: {
                    Image(systemName: "info")
                        .accentColor(self.colorManager.primaryColor)
                }).disabled(!(financialConnection.stockPageData.success ?? false))
                Spacer()
            }
            Divider()
            HStack(spacing: 20) {
                Text(String(format: "$%.2f", financialConnection.stockPageData.currentPrice))
                    .font(Font.custom("DIN-D", size: 24.0))
                    .fontWeight(.semibold)
                    .skeleton(with: !(financialConnection.stockPageData.success ?? false))
                    .animation(type: .pulse())

                Spacer()
            }
            HStack(spacing: 20) {
                Text(DollarString(value: financialConnection.stockPageData.dailyChange) + String(format: "(%.2f%%)", financialConnection.stockPageData.percentChange * 100))
                    .font(Font.custom("DIN-D", size: 20.0))
                    .foregroundColor(profitLossColor(inputDouble: financialConnection.stockPageData.dailyChange))
                    .fontWeight(.semibold)
                    .skeleton(with: !(financialConnection.stockPageData.success ?? false))
                    .animation(type: .pulse())
                Spacer()
            }
        }
    }
    
    func ShowSalePopupView(popupResult: SellResponseCode, message: String) -> some View {
        VStack(spacing: 10) {
            Text(popupResult.description)
                .foregroundColor(.white)
                .fontWeight(.bold)
            Spacer()
            Text(message)
                .font(primaryFont(size: 13))
                .foregroundColor(.white)
                .lineLimit(3)
                .minimumScaleFactor(0.001)
                .frame(minHeight: 60)
                .multilineTextAlignment(.center)
                .scaledToFit()
            Spacer()
            Button(action: {
                // Set all flags to false
                self.presentSuccessAlert = false
                self.showInputTypeAlert = false
            }) {
                Text("Dismiss")
                    .font(primaryFont(size: 14))
                    .foregroundColor(.white)
                    .fontWeight(.bold)
            }
            .frame(width: 100, height: 40)
            .background(CustomColors.shared.secondaryColor)
            .cornerRadius(10)
        }
        .padding(EdgeInsets(top: 70, leading: 20, bottom: 40, trailing: 20))
        .frame(width: 300, height: 300)
        .background(CustomColors.shared.primaryColor)
        .cornerRadius(10.0)
        .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.13), radius: 10.0)
    }

    // View designated for purchasing shares of stock
    var PurchaseStockView: some View {
        VStack {
            Text("Buy \(ticker)")
                .font(primaryFont(size: 24))
                .fontWeight(.medium)
            // Number of Shares
            HStack {
                Text("Number of Shares")
                    .font(primaryFont(size: 14))
                Spacer()
                TextField("0", text: $sharesToBuy)
                    .multilineTextAlignment(.trailing)
                    .textContentType(.creditCardNumber)
                    .font(Font.custom("DIN-D", size: 16.0))
                    .disabled(!(financialConnection.stockPageData.success ?? false))
            }
            Divider()
            // Market Price
            HStack {
                Text("Market Price")
                    .font(primaryFont(size: 14))
                    .fontWeight(.medium)
                Spacer()
                Text(DollarString(value: financialConnection.stockPageData.currentPrice))
                    .font(Font.custom("DIN-D", size: 16.0))
                    .fontWeight(.medium)
                    .skeleton(with: !(financialConnection.stockPageData.success ?? false))
                    .animation(type: .pulse())
            }

            Divider()
            // Purchase Estimated Cost
            HStack {
                Text("Estimated Cost")
                    .font(primaryFont(size: 14))
                    .fontWeight(.medium)
                Spacer()
                Text(DollarString(value: Double(Int(sharesToBuy) ?? 0) * financialConnection.stockPageData.currentPrice))
                    .font(Font.custom("DIN-D", size: 16.0))
                    .fontWeight(.medium)
                    .skeleton(with: !(financialConnection.stockPageData.success ?? false))
                    .animation(type: .pulse())
            }
            Button(action: {
                if let shares = Int(sharesToBuy), shares > 0 {
                    self.successMessage = "You have successfully purchased \(shares) shares of \(ticker)"
                    self.presentSuccessAlert = true
                    self.wallet.buyShare(ticker: ticker, shares: shares, salePrice: financialConnection.stockPageData.currentPrice)
                } else {
                    self.showInputTypeAlert = true
                }
                self.hideKeyboard()
            }, label: {
                Text("Purchase")
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(colorManager.primaryColor))
                    .frame(minWidth: 200)
                    .foregroundColor(colorManager.getPrimaryBackgroundTextColor())
                    .font(primaryFont(size: 18))
            }).buttonStyle(PlainButtonStyle())
        }
        
    }

    // Statistical Information View for Current Stock
    var StatisticsView: some View {
        VStack {
            HStack {
                Text("Statistics")
                    .font(primaryFont(size: 24))
                    .fontWeight(.semibold)
            }
            HStack {
                VStack(spacing: 15) {
                    HStack {
                        Text("Open")
                            .font(primaryFont(size: 14))
                        Spacer()
                        Text(DollarString(value: financialConnection.stockPageData.open))
                            .font(Font.custom("DIN-D", size: 14.0))
                            .skeleton(with: !(financialConnection.stockPageData.success ?? false))
                            .animation(type: .pulse())
                    }
                    Divider()
                    HStack {
                        Text("High")
                            .font(primaryFont(size: 14))
                        Spacer()
                        Text(DollarString(value: financialConnection.stockPageData.high))
                            .font(Font.custom("DIN-D", size: 14.0))
                            .skeleton(with: !(financialConnection.stockPageData.success ?? false))
                            .animation(type: .pulse())
                    }
                    Divider()
                    HStack {
                        Text("Low")
                            .font(primaryFont(size: 14))
                        Spacer()
                        Text(DollarString(value: financialConnection.stockPageData.low))
                            .font(Font.custom("DIN-D", size: 14.0))
                            .skeleton(with: !(financialConnection.stockPageData.success ?? false))
                            .animation(type: .pulse())
                    }
                    Divider()
                    HStack {
                        Text("Year High")
                            .font(primaryFont(size: 14))
                        Spacer()
                        Text(DollarString(value: financialConnection.stockPageData.yearHigh))
                            .font(Font.custom("DIN-D", size: 14.0))
                            .skeleton(with: !(financialConnection.stockPageData.success ?? false))
                            .animation(type: .pulse())
                    }
                    Divider()
                    HStack {
                        Text("Year Low")
                            .font(primaryFont(size: 14))
                        Spacer()
                        Text(DollarString(value: financialConnection.stockPageData.yearLow))
                            .font(Font.custom("DIN-D", size: 14.0))
                            .skeleton(with: !(financialConnection.stockPageData.success ?? false))
                            .animation(type: .pulse())
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
                            .font(primaryFont(size: 14))
                        Spacer()
                        Text(String(financialConnection.stockPageData.volume))
                            .font(Font.custom("DIN-D", size: 14.0))
                            .skeleton(with: !(financialConnection.stockPageData.success ?? false))
                            .animation(type: .pulse())
                    }
                    Divider()
                    HStack {
                        Text("Avg Vol")
                            .font(primaryFont(size: 14))
                        Spacer()
                        Text(String(financialConnection.stockPageData.avgVolume))
                            .font(Font.custom("DIN-D", size: 14.0))
                            .skeleton(with: !(financialConnection.stockPageData.success ?? false))
                            .animation(type: .pulse())
                    }
                    Divider()
                    HStack {
                        Text("Mkt Cap")
                            .font(primaryFont(size: 14))
                        Spacer()
                        Text(String(financialConnection.stockPageData.marketCap))
                            .font(Font.custom("DIN-D", size: 12.0))
                            .skeleton(with: !(financialConnection.stockPageData.success ?? false))
                            .animation(type: .pulse())
                    }
                    Divider()
                    HStack {
                        Text("P/E Ratio")
                            .font(primaryFont(size: 14))
                        Spacer()
                        Text(String(financialConnection.stockPageData.peRatio))
                            .font(Font.custom("DIN-D", size: 14.0))
                            .skeleton(with: !(financialConnection.stockPageData.success ?? false))
                            .animation(type: .pulse())
                    }
                    Divider()
                    HStack {
                        Text("Exchange")
                            .font(primaryFont(size: 14))
                        Spacer()
                        Text(financialConnection.stockPageData.primaryExchange)
                            .font(primaryFont(size: 14))
                            .minimumScaleFactor(0.001)
                            .lineLimit(1)
                            .skeleton(with: !(financialConnection.stockPageData.success ?? false))
                            .animation(type: .pulse())
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
                    .font(primaryFont(size: 24))
                    .fontWeight(.semibold)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 25) {
                    ForEach(financialConnection.stockNewsArticles.indices, id: \.self) { index in
                        NewsArticleView(newsArticle: financialConnection.stockNewsArticles[index])
                            .padding(5)
                    }
                }
            }
        }.multilineTextAlignment(.center)
    }

    var IntradayChartView: some View {
        ZStack {
            VStack {
                Text("Intraday Performance")
                    .padding(.top)
                Text(self.financialConnection.stockPageData.latestTime)
                Spacer()
            }.zIndex(1.0)

            MultiLineChartView(data: [(self.financialConnection.stockChartPoints.map { $0.avgPrice }, GradientColor(start: colorManager.primaryColor, end: colorManager.primaryColor))], title: "", form: ChartForm.large, rateValue: Int(financialConnection.stockPageData.percentChange * 100), dropShadow: false)
                .font(primaryFont(size: 18))
                .zIndex(0.1)
        }
        
    }
    
    
}



extension StockPageView {
    var AnalystRecommendationView: some View {
        VStack {
            Text("Analyst Recommendations")
        }
    }
}

struct StockPageView_Previews: PreviewProvider {
    static var previews: some View {
        StockPageView(ticker: "AAPL")
    }
}
