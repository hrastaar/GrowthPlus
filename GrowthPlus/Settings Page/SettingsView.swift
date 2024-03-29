//
//  SettingsView.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/19/20.
//

import SafariServices
import SwiftUI

struct SettingsView: View {
    @ObservedObject var portfolio = PortfolioManager.shared
    @ObservedObject var colorManager = AppColorManager.shared

    // whether or not to show the Safari ViewController
    @State var showSafari: Bool = false
    @State var showColorView: Bool = false
    @State var showResetAccountAlert: Bool = false
    @State var showTechnologiesView: Bool = false

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Settings")
                    .font(Font.custom("AppleColorEmoji", size: 30.0))
                    .fontWeight(.bold)
                Spacer()
            }
            Spacer()
            LottieView(fileName: "financial_lottie")
                .frame(width: 300)
                .cornerRadius(12)

            Button(action: {
                self.showColorView = true
            }, label: {
                Text("Adjust App Colors")
                    .font(primaryFont(size: 20))
                    .minimumScaleFactor(0.001)
                    .lineLimit(1)
                    .padding()
                    .frame(minWidth: 300)
                    .background(RoundedRectangle(cornerRadius: 10).fill(colorManager.secondaryColor))
                    .cornerRadius(5)
                    .foregroundColor(colorManager.getSecondaryBackgroundTextColor())
            })
                .frame(width: 300)
                .sheet(isPresented: $showColorView) {
                    ColorSelectionView()
                }
            Button(action: {
                self.showTechnologiesView = true
            }, label: {
                Text("Technologies Used")
                    .font(primaryFont(size: 20))
                    .minimumScaleFactor(0.001)
                    .lineLimit(1)
                    .padding()
                    .frame(minWidth: 300)
                    .background(RoundedRectangle(cornerRadius: 10).fill(colorManager.secondaryColor))
                    .cornerRadius(5)
                    .foregroundColor(colorManager.getSecondaryBackgroundTextColor())
            })
                .frame(width: 300)
                .sheet(isPresented: $showTechnologiesView) {
                    TechShowcaseView()
                }

            Button(action: {
                let resetResult = self.portfolio.resetPortfolio()
                colorManager.resetColors()
                if resetResult == true {
                    self.showResetAccountAlert = true
                }
            }, label: {
                Text("Reset Account")
                    .font(primaryFont(size: 20))
                    .minimumScaleFactor(0.001)
                    .lineLimit(1)
                    .padding()
                    .frame(minWidth: 300)
                    .background(RoundedRectangle(cornerRadius: 10).fill(colorManager.primaryColor))
                    .cornerRadius(5)
                    .foregroundColor(colorManager.getPrimaryBackgroundTextColor())
            }).frame(width: 300)
                .alert(isPresented: $showResetAccountAlert, content: {
                    Alert(title:
                        Text("Successfully Reset Account!")
                            .font(Font.custom("DIN-D", size: 24.0)),
                        message:
                        Text("You have successfully reset all account information. Your portfolio holdings and account balances have all been cleared.")
                            .font(Font.custom("DIN-D", size: 18.0)),
                        dismissButton:
                        .default(
                            Text("Dismiss")
                                .font(Font.custom("DIN-D", size: 22.0))
                        ))
                }) // end of alert
            Spacer()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context _: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_: SFSafariViewController, context _: UIViewControllerRepresentableContext<SafariView>) {}
}
