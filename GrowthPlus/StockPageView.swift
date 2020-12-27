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
    @ObservedObject var financialConnection = FinancialAPIConnection.shared
    @ObservedObject var colorManager = CustomColors.shared
    
    @State var sharesToBuy: String = ""
    @State var showInputTypeAlert: Bool = false
    @State var presentSuccessAlert: Bool = false
    @State private var showOrderConfirmationConfetti: Bool = false
    @State private var showCompanyProfilePopoverView: Bool = false
    @Environment(\.colorScheme) var colorScheme
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

    }

    // Stock Heading: Ticker, Company Name, Price, Daily Change
    var StockHeaderView: some View {
        VStack {
            HStack(spacing: 20) {
                Text(financialConnection.stockPageData.ticker)
                    .font(Font.custom("AppleColorEmoji", size: 18.0))
                    .fontWeight(.medium)
                Spacer()
            }
            HStack(spacing: 20) {
                Text(financialConnection.stockPageData.companyName)
                    .font(Font.custom("AppleColorEmoji", size: 24.0))
                    .fontWeight(.semibold)
                Button(action: {
                    self.showCompanyProfilePopoverView.toggle()
                }, label: {
                    Image(systemName: "info")
                })
                Spacer()
            }
            Divider()
            HStack(spacing: 20) {
                Text(String(format: "$%.2f", financialConnection.stockPageData.currentPrice))
                    .font(Font.custom("DIN-D", size: 24.0))
                    .fontWeight(.semibold)
                Spacer()
            }
            HStack(spacing: 20) {
                Text(DollarString(value: financialConnection.stockPageData.dailyChange) + String(format: "(%.2f%%)", financialConnection.stockPageData.percentChange * 100))
                    .font(Font.custom("DIN-D", size: 20.0))
                    .foregroundColor(profitLossColor(inputDouble: financialConnection.stockPageData.dailyChange))
                    .fontWeight(.semibold)
                Spacer()
            }
        }
    }

    // View designated for purchasing shares of stock
    var PurchaseStockView: some View {
        VStack {
            Text("Buy \(ticker)")
                .font(Font.custom("AppleColorEmoji", size: 24.0))
                .fontWeight(.medium)
            // Number of Shares
            HStack {
                Text("Number of Shares")
                    .font(Font.custom("AppleColorEmoji", size: 14.0))
                Spacer()
                TextField("0", text: $sharesToBuy)
                    .multilineTextAlignment(.trailing)
                    .textContentType(.creditCardNumber)
                    .font(Font.custom("DIN-D", size: 16.0))
            }
            Divider()
            // Market Price
            HStack {
                Text("Market Price")
                    .font(Font.custom("AppleColorEmoji", size: 14.0))
                    .fontWeight(.medium)
                Spacer()
                Text(DollarString(value: financialConnection.stockPageData.currentPrice))
                    .font(Font.custom("DIN-D", size: 16.0))
                    .fontWeight(.medium)
            }

            Divider()
            // Purchase Estimated Cost
            HStack {
                Text("Estimated Cost")
                    .font(Font.custom("AppleColorEmoji", size: 14.0))
                    .fontWeight(.medium)
                Spacer()
                Text(DollarString(value: Double(Int(sharesToBuy) ?? 0) * financialConnection.stockPageData.currentPrice))
                    .font(Font.custom("DIN-D", size: 16.0))
                    .fontWeight(.medium)
            }
            Button(action: {
                if let shares = Int(sharesToBuy) {
                    self.presentSuccessAlert.toggle()
                    self.wallet.buyShare(ticker: ticker, shares: shares, salePrice: financialConnection.stockPageData.currentPrice)
                } else {
                    showInputTypeAlert.toggle()
                }
            }, label: {
                Text("Purchase")
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(CustomColors.shared.primaryColor))
                    .frame(minWidth: 200)
                    .foregroundColor(UIColor(colorManager.primaryColor).isLight()! && colorManager.primaryColor != Color(UIColor(hex: "#1ce4ac")) ? Color.black : Color.white)
                    .font(Font.custom("AppleColorEmoji", size: 18.0))
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
                Text("Statistics")
                    .font(.custom("AppleColorEmoji", size: 24))
                    .fontWeight(.semibold)
            }
            HStack {
                VStack(spacing: 15) {
                    HStack {
                        Text("Open")
                            .font(Font.custom("AppleColorEmoji", size: 14.0))
                        Spacer()
                        Text(DollarString(value: financialConnection.stockPageData.open))
                            .font(Font.custom("DIN-D", size: 14.0))
                    }
                    Divider()
                    HStack {
                        Text("High")
                            .font(Font.custom("AppleColorEmoji", size: 14.0))
                        Spacer()
                        Text(DollarString(value: financialConnection.stockPageData.high))
                            .font(Font.custom("DIN-D", size: 14.0))
                    }
                    Divider()
                    HStack {
                        Text("Low")
                            .font(Font.custom("AppleColorEmoji", size: 14.0))
                        Spacer()
                        Text(DollarString(value: financialConnection.stockPageData.low))
                            .font(Font.custom("DIN-D", size: 14.0))
                    }
                    Divider()
                    HStack {
                        Text("Year High")
                            .font(Font.custom("AppleColorEmoji", size: 14.0))
                        Spacer()
                        Text(DollarString(value: financialConnection.stockPageData.yearHigh))
                            .font(Font.custom("DIN-D", size: 14.0))
                    }
                    Divider()
                    HStack {
                        Text("Year Low")
                            .font(Font.custom("AppleColorEmoji", size: 14.0))
                        Spacer()
                        Text(DollarString(value: financialConnection.stockPageData.yearLow))
                            .font(Font.custom("DIN-D", size: 14.0))
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
                            .font(Font.custom("AppleColorEmoji", size: 14.0))
                        Spacer()
                        Text(String(financialConnection.stockPageData.volume))
                            .font(Font.custom("DIN-D", size: 14.0))
                    }
                    Divider()
                    HStack {
                        Text("Avg Vol")
                            .font(Font.custom("AppleColorEmoji", size: 14.0))
                        Spacer()
                        Text(String(financialConnection.stockPageData.avgVolume))
                            .font(Font.custom("DIN-D", size: 14.0))
                    }
                    Divider()
                    HStack {
                        Text("Mkt Cap")
                            .font(Font.custom("AppleColorEmoji", size: 14.0))
                        Spacer()
                        Text(String(financialConnection.stockPageData.marketCap))
                            .font(Font.custom("DIN-D", size: 12.0))
                    }
                    Divider()
                    HStack {
                        Text("P/E Ratio")
                            .font(Font.custom("AppleColorEmoji", size: 14.0))
                        Spacer()
                        Text(String(format: "%.2f", financialConnection.stockPageData.peRatio))
                            .font(Font.custom("DIN-D", size: 14.0))
                    }
                    Divider()
                    HStack {
                        Text("Exchange")
                            .font(Font.custom("AppleColorEmoji", size: 14.0))
                        Spacer()
                        Text(financialConnection.stockPageData.primaryExchange)
                            .font(Font.custom("AppleColorEmoji", size: 14.0))
                            .minimumScaleFactor(0.001)
                            .lineLimit(1)
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
                    .font(.custom("AppleColorEmoji", size: 24))
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

            MultiLineChartView(data: [(self.financialConnection.stockChartPoints.map { $0.avgPrice }, GradientColor(start: CustomColors.shared.primaryColor, end: CustomColors.shared.primaryColor))], title: "", form: ChartForm.large, rateValue: Int(financialConnection.stockPageData.percentChange * 100), dropShadow: false)
                .font(Font.custom("AppleColorEmoji", size: 18.0))
                .zIndex(0.1)
        }
        
    }
    
    
}

// Extention for popover view
extension StockPageView {
    var CompanyInfoPopoverView: some View {
        VStack {
            HStack {
                Button(action: {
                    self.showCompanyProfilePopoverView = false
                    print("turned false")
                }, label: {
                    Text("X")
                        .font(.custom("AppleColorEmoji", size: 24))
                })
                Spacer()
                Text(financialConnection.companyProfile.ticker)
                    .font(.custom("AppleColorEmoji", size: 12))
                Divider()
                    .background(Color.white)
                    .frame(height: 15)
                Text(financialConnection.companyProfile.exchange)
                    .font(.custom("AppleColorEmoji", size: 12))
            }.onTapGesture {
                self.showCompanyProfilePopoverView = false
            }
            .padding(.horizontal)
            .padding(.top)
            Text(financialConnection.companyProfile.companyName)
                .font(.custom("AppleColorEmoji", size: 20))
            ScrollView {
                VStack(spacing: 20) {
                    Section {
                        HStack {
                            Text("Industry")
                                .font(.custom("AppleColorEmoji", size: 15))
                            Spacer()
                            Text(financialConnection.companyProfile.industry)
                                .font(.custom("AppleColorEmoji", size: 15))
                        }
                        HStack {
                            Text("CEO")
                                .font(.custom("AppleColorEmoji", size: 15))
                            Spacer()
                            Text(financialConnection.companyProfile.CEO)
                                .font(.custom("AppleColorEmoji", size: 15))
                        }
                        HStack {
                            Text("No. of Employees")
                                .font(.custom("AppleColorEmoji", size: 15))
                            Spacer()
                            Text(String(financialConnection.companyProfile.numEmployees))
                                .font(.custom("DIN-D", size: 15))
                        }
                        Text("Description")
                            .font(.custom("AppleColorEmoji", size: 15))
                        Text(financialConnection.companyProfile.description.isEmpty ? "Not Available" : "\t" + financialConnection.companyProfile.description)
                            .font(.custom("AppleColorEmoji", size: 12))
                            .multilineTextAlignment(.leading)
                    }.padding(.horizontal)
                    Divider()
                        .background(colorManager.primaryColor)
                        .frame(width: UIScreen.main.bounds.width - 75)
                    Section {
                        Text("Company Tags")
                            .font(.custom("AppleColorEmoji", size: 18))
                        ForEach(financialConnection.companyProfile.tags.indices, id: \.self) { index in
                            HStack {
                                Text(financialConnection.companyProfile.tags[index])
                                    .padding(3)
                                    .background(colorManager.primaryColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(14)
                                    .font(.custom("AppleColorEmoji", size: 12))
                            }
                        }
                    }
                    Divider()
                        .background(colorManager.primaryColor)
                        .frame(width: UIScreen.main.bounds.width - 75)
                    Section {
                        VStack {
                            Text("Company Address")
                                .font(.custom("AppleColorEmoji", size: 18))
                            Text(financialConnection.companyProfile.address)
                                .font(.custom("AppleColorEmoji", size: 13))
                            HStack {
                                Text(financialConnection.companyProfile.city + ", " + financialConnection.companyProfile.state)
                                    .font(.custom("AppleColorEmoji", size: 13))
                                Text(financialConnection.companyProfile.zip)
                                    .font(.custom("DIN-D", size: 13))
                            }
                            Text(financialConnection.companyProfile.phone)
                                .font(.custom("DIN-D", size: 13))
                        }
                    }.padding(.bottom)
                }
                
            }
        }
        .frame(width: UIScreen.main.bounds.width - 10, height: UIScreen.main.bounds.height - 75, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .background(Color.init(white: 0.07).opacity(0.95))
        .foregroundColor(.white)
        .cornerRadius(12.5)
        .padding()
    }
}

struct StockPageView_Previews: PreviewProvider {
    static var previews: some View {
        StockPageView(ticker: "AAPL")
    }
}
