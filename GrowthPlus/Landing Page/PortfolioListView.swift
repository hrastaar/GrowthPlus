//
//  PortfolioListView.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/12/20.
//

import SwiftUI

struct PortfolioListView: View {
    @ObservedObject var wallet = PortfolioManager.shared
    @State var showOrderView: Bool = false
    var HeaderView: some View {
        HStack {
            Text("Your Portfolio")
                .font(primaryFont(size: 24))
                .fontWeight(.bold)
            Spacer()
        }
    }

    var body: some View {
        VStack {
            HeaderView
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(wallet.portfolioCards.indices, id: \.self) { index in
                        StockCardView(card: wallet.portfolioCards[index])
                            .onTapGesture {
                                wallet.portfolioCards.indices.forEach { index in
                                    wallet.portfolioCards[index].isSelected = false
                                }
                                wallet.portfolioCards[index].isSelected = true
                                wallet.selectedCard = wallet.portfolioCards[index]
                            }
                            .frame(width: 100, height: 170)
                            .padding(5)
                    }
                } /// end of HStack
            } /// end of ScrollView
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
