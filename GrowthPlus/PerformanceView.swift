//
//  PerformanceView.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/12/20.
//

import SwiftUI

struct PerformanceView: View {
    @ObservedObject var wallet = Portfolio.shared
    @State private var incomePercentage = 0
    var PerformanceHeaderView: some View {
        VStack {
            Text(wallet.selectedCard.companyName)
                .font(Font.custom("DIN-D", size: 24.0))
                .fontWeight(.bold)
            Divider()
            HStack {
                Text("Equity Owned")
                    .font(Font.custom("DIN-D", size: 20.0))
                    .fontWeight(.bold)
                Spacer()
                Text(DollarString(value: wallet.selectedCard.equity))
                    .font(Font.custom("DIN-D", size: 20.0))
                    .fontWeight(.semibold)
                    .foregroundColor(CustomColors.shared.primaryColor)
                    .padding(.trailing)
                    .fixedSize()
            }
        }
    }
    
    var PriceView: some View {
        HStack(spacing: 10) {
            Image(systemName: "arrow.up")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(CustomColors.shared.primaryColor)
                .padding(10)
                .background(CustomColors.shared.primaryColor)
                .opacity(0.2)
                .cornerRadius(10)
            VStack(alignment: .leading) {
                Text("Current Price")
                    .fixedSize()
                    .font(Font.custom("DIN-D", size: 18.0))
                    .foregroundColor(Color(.systemGray3))
                Text(DollarString(value: wallet.selectedCard.currentPrice))
                    .font(Font.custom("DIN-D", size: 18.0))
                    .fontWeight(.bold)
            }
        }
    }
    
    var CostView: some View {
        HStack(spacing: 10) {
            Image(systemName: "arrow.down")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(CustomColors.shared.secondaryColor)
                .padding(10)
                .background(CustomColors.shared.secondaryColor)
                .opacity(0.2)
                .cornerRadius(10)
            VStack(alignment: .leading) {
                Text("Avg Cost")
                    .font(Font.custom("DIN-D", size: 18.0))
                    .foregroundColor(Color(.systemGray3))
                Text(DollarString(value: wallet.selectedCard.avgCost))
                    .font(Font.custom("DIN-D", size: 18.0))
                    .fontWeight(.bold)
            }
        }
    }
    
    var DailyPerformanceView: some View {
        HStack(spacing: 10) {
            VStack(alignment: .center) {
                Text("Today's Return")
                    .font(Font.custom("DIN-D", size: 18.0))
                    .foregroundColor(Color(.systemGray3))
                Text(DollarString(value: wallet.selectedCard.dailyChange * Double(wallet.selectedCard.shares)))
                    .font(Font.custom("DIN-D", size: 18.0))
                    .fontWeight(.bold)
                Text(String(format: "(\(wallet.selectedCard.dailySign)%.2f%%)", abs(wallet.selectedCard.percentChange * 100)))
                    .font(Font.custom("DIN-D", size: 18.0))
                    .fontWeight(.bold)
            }
        }
    }
    
    var TotalPerformanceView: some View {
        HStack(spacing: 10) {
            VStack(alignment: .center) {
                Text("Total Return")
                    .font(Font.custom("DIN-D", size: 18.0))
                    .foregroundColor(Color(.systemGray3))
                Text(DollarString(value: wallet.selectedCard.netProfit))
                    .font(Font.custom("DIN-D", size: 18.0))
                    .fontWeight(.bold)
                Text(String(format: "(\(wallet.selectedCard.totalSign)%.2f%%)",abs(wallet.selectedCard.netProfit * 100)/wallet.selectedCard.totalCost))
                    .font(Font.custom("DIN-D", size: 18.0))
                    .fontWeight(.bold)
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 15) {
            PerformanceHeaderView
            HorizontalProgressView(percentage: $incomePercentage)
                .padding(.bottom, 15)
            HStack {
                PriceView
                Spacer()
                CostView
            }
            Spacer()
            HStack {
                DailyPerformanceView
                Spacer()
                TotalPerformanceView
            }
        }
        .onAppear {
            update()
        }
        .onChange(of: wallet.selectedCard) { _ in
            update()
        }
    }
    
    private func update() {
        withAnimation(.spring(response: 2)) {
            incomePercentage = Int((wallet.selectedCard.equity / wallet.totalStockValue) * 100)
        }
    }
}

struct PerformanceView_Previews: PreviewProvider {
    static var previews: some View {
        PerformanceView()
            .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            .padding()
    }
}
