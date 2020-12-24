//
//  InvestmentHeaderView.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/13/20.
//

import SwiftUI

struct InvestmentHeaderView: View {
    @ObservedObject var wallet: Portfolio = Portfolio.shared
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Investments")
                    .font(Font.custom("D-DIN", size: 30.0))
                    .fontWeight(.bold)
                Spacer()
            }
            HStack {
                Text(String(format: "$%.2f", wallet.totalStockValue))
                    .font(Font.custom("DIN-D", size: 24.0))
                    .fontWeight(.semibold)
                Spacer()
            }
            Divider()
            HStack {
                Text("Realized Gains")
                    .font(Font.custom("DIN-D", size: 16.0))
                    .fontWeight(.semibold)
                Spacer()
                Text(DollarString(value: wallet.realizedGains))
                    .font(Font.custom("DIN-D", size: 16.0))
                    .fontWeight(.semibold)
                    .foregroundColor(profitLossColor(inputDouble: wallet.realizedGains))
            }
            HStack {
                Text("Unrealized Gains")
                    .font(Font.custom("DIN-D", size: 16.0))
                    .fontWeight(.semibold)
                Spacer()
                Text(DollarString(value: wallet.unrealizedGains))
                    .font(Font.custom("DIN-D", size: 16.0))
                    .fontWeight(.semibold)
                    .foregroundColor(profitLossColor(inputDouble: wallet.unrealizedGains))
            }
            Divider()
        }
    }
}

struct InvestmentHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        InvestmentHeaderView()
    }
}
