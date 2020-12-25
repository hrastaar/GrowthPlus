//
//  NewsArticleView.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/24/20.
//

import SafariServices
import SwiftUI

struct NewsArticleView: View {
    let newsArticle: StockNewsArticle
    @State var showArticle: Bool = false
    @ObservedObject var colorPalette = CustomColors.shared

    var body: some View {
        VStack {
            HStack {
                Text(newsArticle.source)
                    .font(Font.custom("DIN-D", size: 22.0))
                    .frame(width: 150)
            }
            .frame(height: 60)
            .padding(.horizontal)
            .padding(.top)
            Text(newsArticle.headline)
                .font(Font.custom("DIN-D", size: 18.0))
                .fontWeight(.semibold)
                .padding(.bottom)
                .padding(.horizontal)
                .frame(height: 100)
        }
        .background(colorPalette.primaryColor)
        .foregroundColor(UIColor(colorPalette.primaryColor).isLight()! ? Color.black : Color.white)
        .cornerRadius(15)
        .frame(width: 300, height: 175)
        .onTapGesture {
            showArticle = true
        }
        .sheet(isPresented: $showArticle) {
            SafariView(url: newsArticle.articleURL)
        }
    }
}

struct NewsArticleView_Previews: PreviewProvider {
    static var previews: some View {
        NewsArticleView(newsArticle:
            StockNewsArticle(date: 1_608_239_100_000,
                             ticker: "PLTR",
                             headline: "Palantir Announces Inaugural Live Demo Day on January 26, 2021",
                             source: "Business Wire",
                             articleURL: URL(string: "https://cloud.iexapis.com/v1/news/article/e421c573-2b1d-4a4c-ac50-60955c27c15c")!,
                             related: ["PLTR"],
                             imageURL: URL(string: "https://cloud.iexapis.com/v1/news/image/e421c573-2b1d-4a4c-ac50-60955c27c15c")!)
        )
    }
}
