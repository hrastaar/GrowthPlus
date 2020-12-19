//
//  PortfolioListView.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/12/20.
//

import SwiftUI

struct PortfolioListView: View {
    @ObservedObject var wallet = Portfolio.shared
    @State var showOrderView = false
    var HeaderView: some View {
        HStack {
            Text("Your Portfolio")
                .font(Font.custom("DIN-D", size: 24.0))
                .fontWeight(.bold)
            Spacer()
        }
    }
    
    var body: some View {
        VStack {
            HeaderView
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(wallet.portfolioCards.indices, id: \.self) { index in
                        StockView(card: wallet.portfolioCards[index])
                            .onTapGesture {
                                wallet.portfolioCards.indices.forEach { index in
                                    wallet.portfolioCards[index].isSelected = false
                                }
                                wallet.portfolioCards[index].isSelected = true
                            }
                    }
                }
            }
        }
    }
}

struct PortfolioListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PortfolioListView()
        }
    }
}
