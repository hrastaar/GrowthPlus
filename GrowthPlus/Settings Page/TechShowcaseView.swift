//
//  TechnologiesUsedView.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/19/20.
//

import SwiftUI

struct TechShowcaseView: View {
    var body: some View {
        ZStack {
            Color(white: 0.96)
                .ignoresSafeArea()
            VStack(alignment: .center, spacing: 10) {
                Spacer()
                HStack {
                    Spacer()
                    Text("Technologies Used to Build GrowthPlus")
                        .font(primaryFont(size: 24.0))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
                LottieView(fileName: "technology")
                    .frame(width: UIScreen.main.bounds.width - 25)
                Divider()
                Text("These are the fantastic tools and libraries used to build this app!")
                    .font(primaryFont(size: 14.0))
                    .foregroundColor(.black)
                Divider()
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 25) {
                        ForEach(technologies.indices, id: \.self) { index in
                            IndividualTechnologyView(technology: technologies[index])
                                .frame(width: UIScreen.main.bounds.width * 0.67, height: 500)
                        }
                    }
                }.padding(.horizontal)
            }
        }
    }
}

struct TechnologiesUsedView_Previews: PreviewProvider {
    static var previews: some View {
        TechShowcaseView()
    }
}
