//
//  CryptoCardView.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 1/14/21.
//

import SwiftUI

struct CryptoCardView: View {
    @ObservedObject var colorManager = AppColorManager.shared
    @ObservedObject var cryptoData: CryptocurrencyData
    var body: some View {
        VStack {
            Text(cryptoData.ticker)
                .fontWeight(.semibold)
                .minimumScaleFactor(0.001)
                .lineLimit(2)
            Spacer()
            Text(cryptoData.price)
                .fontWeight(.bold)
            Spacer()
            Text(cryptoData.date)
                .font(Font.custom("DIN-D", size: 10))
        }
        .padding(.vertical, 10)
        .frame(width: 180, height: 100)
        .foregroundColor(colorManager.getPrimaryBackgroundTextColor())
        .background(colorManager.primaryColor)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(colorManager.secondaryColor, lineWidth: 5)
        )
        .font(Font.custom("DIN-D", size: 18.0))
        .cornerRadius(20)
        .multilineTextAlignment(.center)
    }
}

struct CryptoCardView_Previews: PreviewProvider {
    static var previews: some View {
        CryptoCardView(cryptoData: CryptocurrencyData(ticker: "ETHUSD", price: "$1250.00", date: 1610677742319))
    }
}
