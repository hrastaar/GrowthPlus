//
//  CryptoCardView.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 1/14/21.
//

import SwiftUI

struct CryptoCardView: View {
    @ObservedObject var financialAPIConnection = FinancialAPIConnection.shared
    @ObservedObject var colorManager = AppColorManager.shared

    var body: some View {
        VStack {
            Text("Bitcoin")
                .fontWeight(.semibold)
                .minimumScaleFactor(0.001)
                .lineLimit(2)
            Spacer()
            Text(financialAPIConnection.cryptoData?.price ?? "Not Available")
                .fontWeight(.bold)
            Spacer()
            Text(financialAPIConnection.cryptoData?.date ?? "")
                .font(Font.custom("DIN-D", size: 10))
        }
        .padding(.vertical, 10)
        .frame(width: 180, height: 100)
        .foregroundColor(colorManager.getPrimaryBackgroundTextColor())
        .background(colorManager.primaryColor)
        .font(Font.custom("DIN-D", size: 18.0))
        .cornerRadius(15)
        .multilineTextAlignment(.center)
    }
}

struct CryptoCardView_Previews: PreviewProvider {
    static var previews: some View {
        CryptoCardView()
    }
}
