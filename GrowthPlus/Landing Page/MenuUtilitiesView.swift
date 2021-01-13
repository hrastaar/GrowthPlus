//
//  MenuUtilitiesView.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/23/20.
//

import SwiftUI

struct MenuUtilitiesView: View {
    @ObservedObject var colorManager = AppColorManager.shared

    var body: some View {
        HStack {
            NavigationLink(
                destination: SettingsView(),
                label: {
                    Image(systemName: "gear")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(10)
                        .background(colorManager.primaryColor)
                        .cornerRadius(10)
                }
            )
            Spacer()
            NavigationLink(
                destination: DiscoverView(),
                label: {
                    Image(systemName: "book")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(10)
                        .background(colorManager.primaryColor)
                        .cornerRadius(10)
                }
            )
            Spacer()
            NavigationLink(
                destination: SearchStockView(),
                label: {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(10)
                        .background(colorManager.primaryColor)
                        .cornerRadius(10)
                }
            )
        }.foregroundColor(colorManager.getPrimaryBackgroundTextColor())
    }
}

struct MenuUtilitiesView_Previews: PreviewProvider {
    static var previews: some View {
        MenuUtilitiesView()
    }
}
