//
//  SettingsView.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/19/20.
//

import SwiftUI
import SafariServices
import Lottie

struct SettingsView: View {
    @ObservedObject var portfolio: Portfolio = Portfolio.shared
    // whether or not to show the Safari ViewController
    @State var showSafari: Bool = false
    @State var showColorView: Bool = false
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
            LottieView(fileName: "financial_lottie")
                .frame(width: 300)
            
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
            
            Button(action: {
                self.showSafari = true
            }, label: {
                Text("Meet the Developer")
                    .font(Font.custom("DIN-D", size: 22.0))
                    .padding()
                    .frame(minWidth: 300)
                    .background(RoundedRectangle(cornerRadius: 10).fill(CustomColors.shared.secondaryColor))
                    .cornerRadius(5)
                    .foregroundColor(.white)
            })
                .frame(width: 300)
                .sheet(isPresented: $showSafari) {
                    SafariView(url:URL(string: self.urlString)!)
                }
            
            Button(action: {
                let resetResult = self.portfolio.resetPortfolio()
                if resetResult == true {
                    print("Success")
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
