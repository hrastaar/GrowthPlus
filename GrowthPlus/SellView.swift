//
//  SellView.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/13/20.
//

import SwiftUI

struct SellView: View {
    @ObservedObject var wallet: Portfolio
    init() {
        wallet = Portfolio.shared
    }

    @State var sharesToSell: String = ""
    @State var showInputTypeAlert = false
    @State var showInvalidSharesNumberAlert = false
    var body: some View {
        // Sell Section
        VStack {
            Text("Sell \(wallet.selectedCard.ticker)")
                .font(primaryFont(size: 20))
                .fontWeight(.medium)
            Spacer()
            // Number of Shares
            HStack {
                Text("Number of Shares")
                    .font(primaryFont(size: 14))
                Spacer()
                TextField("0", text: $sharesToSell)
                    .multilineTextAlignment(.trailing)
                    .textContentType(.creditCardNumber)
                    .font(Font.custom("DIN-D", size: 16.0))
            }
            Divider()
            // Market Price
            HStack {
                Text("Market Price")
                    .font(primaryFont(size: 14))
                    .fontWeight(.medium)
                Spacer()
                Text(DollarString(value: wallet.selectedCard.currentPrice))
                    .font(Font.custom("DIN-D", size: 16.0))
                    .fontWeight(.medium)
            }

            Divider()
            // Purchase Estimated Cost
            HStack {
                Text("Estimated Credit")
                    .font(primaryFont(size: 14))
                    .fontWeight(.medium)
                Spacer()
                Text(DollarString(value: Double(Int(sharesToSell) ?? 0) * wallet.selectedCard.currentPrice))
                    .font(Font.custom("DIN-D", size: 18.0))
                    .fontWeight(.medium)
            }
            Divider()
            Button(action: {
                if let numShares = Int(sharesToSell) {
                    print(numShares)
                    print("available: \(wallet.selectedCard.shares)")
                    if numShares > wallet.selectedCard.shares {
                        showInvalidSharesNumberAlert.toggle()
                    } else {
                        wallet.sellShare(ticker: wallet.selectedCard.ticker, shares: numShares, salePrice: wallet.selectedCard.currentPrice, avgPrice: wallet.selectedCard.avgCost)
                    }
                } else {
                    self.showInputTypeAlert.toggle()
                }
            }, label: {
                Text("Sell")
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(CustomColors.shared.primaryColor))
                    .frame(minWidth: 200)
                    .foregroundColor(.white)
                    .font(primaryFont(size: 18))
            }).buttonStyle(PlainButtonStyle())
        }.alert(isPresented: $showInputTypeAlert, content: {
            Alert(
                title:
                Text("Invalid Number of Shares")
                    .font(Font.custom("DIN-D", size: 20.0)),
                message:
                Text("Please check that your input for number of shares to sell is a valid whole number")
                    .font(Font.custom("DIN-D", size: 18.0)),
                dismissButton:
                .default(
                    Text("Dismiss")
                        .font(Font.custom("DIN-D", size: 20.0)),
                    action: {}
                )
            )
        }) // end of alert
            .alert(isPresented: $showInvalidSharesNumberAlert, content: {
                Alert(title: Text("Not Enough Shares"), message: Text("You can sell at most \(wallet.selectedCard.shares) shares of \(wallet.selectedCard.ticker)"), dismissButton: .default(Text("Dismiss"), action: {}))
            }) // end of alert
    }
}

struct SellView_Previews: PreviewProvider {
    static var previews: some View {
        SellView()
    }
}
