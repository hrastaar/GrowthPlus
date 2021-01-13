//
//  StockPerformanceView.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/12/20.
//

import SwiftUI

struct StockPerformanceView: View {
    @ObservedObject var wallet = PortfolioManager.shared
    @ObservedObject var colorManager = AppColorManager.shared
    @State private var incomePercentage: Int = 0

    var body: some View {
        if wallet.selectedCard != nil {
            VStack(spacing: 15) {
                PerformanceHeaderView
                HorizontalProgressView(percentage: $incomePercentage)
                    .padding(.bottom, 15)
                HStack {
                    VStack {
                        PriceView
                        Spacer()
                        DailyPerformanceView
                    }
                    Spacer()
                    VStack {
                        CostView
                        Spacer()
                        TotalPerformanceView
                    }
                }
            }
            .onAppear {
                update()
            }
            .onChange(of: wallet.selectedCard) { _ in
                update()
            }
            .onChange(of: wallet.portfolioCards) { _ in
                update()
            }
        }
    }

    var PerformanceHeaderView: some View {
        VStack {
            Text(wallet.selectedCard!.companyName)
                .font(primaryFont(size: 20))
                .fontWeight(.bold)
                .minimumScaleFactor(0.001)
                .lineLimit(1)
                .frame(height: 50)
            Divider()
            HStack {
                Text("Equity Owned")
                    .font(primaryFont(size: 16))
                    .fontWeight(.bold)
                Spacer()
                Text(DollarString(value: wallet.selectedCard!.calculateEquity()))
                    .font(Font.custom("DIN-D", size: 20.0))
                    .fontWeight(.semibold)
                    .foregroundColor(colorManager.primaryColor)
                    .padding(.trailing)
                    .fixedSize()
            }
        }
    }

    var PriceView: some View {
        HStack(spacing: 10) {
            VStack(alignment: .center) {
                Text("Current Price")
                    .minimumScaleFactor(0.001)
                    .lineLimit(1)
                    .font(primaryFont(size: 16))
                    .foregroundColor(Color(.systemGray3))
                Text(DollarString(value: wallet.selectedCard!.currentPrice))
                    .font(Font.custom("DIN-D", size: 18.0))
                    .fontWeight(.bold)
            }
        }
    }

    var CostView: some View {
        HStack(spacing: 10) {
            VStack(alignment: .center) {
                Text("Avg Cost")
                    .font(primaryFont(size: 16))
                    .foregroundColor(Color(.systemGray3))
                Text(DollarString(value: wallet.selectedCard!.avgCost))
                    .font(Font.custom("DIN-D", size: 18.0))
                    .fontWeight(.bold)
            }
        }
    }

    var DailyPerformanceView: some View {
        HStack(spacing: 10) {
            VStack(alignment: .center) {
                Text("Today's Return")
                    .font(primaryFont(size: 16))
                    .foregroundColor(Color(.systemGray3))
                Text(DollarString(value: wallet.selectedCard!.dailyChange * Double(wallet.selectedCard!.shares)))
                    .font(Font.custom("DIN-D", size: 18.0))
                    .fontWeight(.bold)
                Text(String(format: "(\(wallet.selectedCard!.dailySign)%.2f%%)", abs(wallet.selectedCard!.percentChange * 100)))
                    .font(Font.custom("DIN-D", size: 18.0))
                    .fontWeight(.bold)
            }
        }
    }

    var TotalPerformanceView: some View {
        HStack(spacing: 10) {
            VStack(alignment: .center) {
                Text("Total Return")
                    .font(primaryFont(size: 16))
                    .foregroundColor(Color(.systemGray3))
                Text(DollarString(value: wallet.selectedCard!.calculateNetProfit()))
                    .font(Font.custom("DIN-D", size: 18.0))
                    .fontWeight(.bold)
                Text(String(format: "(\(wallet.selectedCard!.totalSign)%.2f%%)", abs(wallet.selectedCard!.calculateNetProfit() * 100) / wallet.selectedCard!.calculateTotalCost()))
                    .font(Font.custom("DIN-D", size: 18.0))
                    .fontWeight(.bold)
            }
        }
    }

    private func update() {
        withAnimation(.spring(response: 2)) {
            if wallet.portfolioCards.count > 0 {
                incomePercentage = Int((wallet.selectedCard!.calculateEquity() / wallet.totalStockValue) * 100)
            }
        }
    }
}

#if DEBUG
    struct PerformanceView_Previews: PreviewProvider {
        static var previews: some View {
            StockPerformanceView()
                .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                .padding()
        }
    }
#endif
