//
//  SettingsView.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/19/20.
//

import SwiftUI
import SafariServices

struct SettingsView: View {
    @ObservedObject var portfolio: Portfolio = Portfolio.shared
    // whether or not to show the Safari ViewController
    @State var showSafari: Bool = false
    @State var showColorView: Bool = false
    @State var showResetAccountAlert: Bool = false
    @State var showTechnologiesView: Bool = false
        // initial URL string
    @State var urlString: String = "https://www.linkedin.com/in/rastaarhaghi"
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Settings")
                    .font(Font.custom("DIN-D", size: 30.0))
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
                    .font(Font.custom("DIN-D", size: 22.0))
                    .padding()
                    .frame(minWidth: 300)
                    .background(RoundedRectangle(cornerRadius: 10).fill(CustomColors.shared.secondaryColor))
                    .cornerRadius(5)
                    .foregroundColor(.white)
            })
                .frame(width: 300)
                .sheet(isPresented: $showColorView) {
                    ColorSelectionView()
                }
            
//            Button(action: {
//                self.showSafari = true
//            }, label: {
//                Text("Meet the Developer")
//                    .font(Font.custom("DIN-D", size: 22.0))
//                    .padding()
//                    .frame(minWidth: 300)
//                    .background(RoundedRectangle(cornerRadius: 10).fill(CustomColors.shared.secondaryColor))
//                    .cornerRadius(5)
//                    .foregroundColor(.white)
//            })
//                .frame(width: 300)
//                .sheet(isPresented: $showSafari) {
//                    SafariView(url:URL(string: self.urlString)!)
//                }
            
            Button(action: {
                self.showTechnologiesView = true
            }, label: {
                Text("Technologies Used in App")
                    .font(Font.custom("DIN-D", size: 22.0))
                    .padding()
                    .frame(minWidth: 300)
                    .background(RoundedRectangle(cornerRadius: 10).fill(CustomColors.shared.secondaryColor))
                    .cornerRadius(5)
                    .foregroundColor(.white)
            })
                .frame(width: 300)
                .sheet(isPresented: $showTechnologiesView) {
                    TechnologiesUsedView()
                }
            
            Button(action: {
                let resetResult = self.portfolio.resetPortfolio()
                CustomColors.shared.resetColors()
                if resetResult == true {
                    self.showResetAccountAlert = true
                }
            }, label: {
                Text("Reset Account")
                    .font(Font.custom("DIN-D", size: 22.0))
                    .padding()
                    .frame(minWidth: 300)
                    .background(RoundedRectangle(cornerRadius: 10).fill(CustomColors.shared.primaryColor))
                    .cornerRadius(5)
                    .foregroundColor(.white)
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
                        )
                )
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

    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {

    }

}
