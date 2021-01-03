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
        VStack(alignment: .center) {
            HStack {
                Text(newsArticle.source)
                    .font(primaryFont(size: 16))
                    .frame(width: 150)
            }
            .frame(height: 60)
            .padding(.horizontal)

            Text(newsArticle.headline)
                .font(primaryFont(size: 13))
                .fontWeight(.semibold)
                .padding(.bottom)
                .padding(.horizontal)
                .frame(height: 100)
        }
        .background(colorPalette.primaryColor)
        .foregroundColor(UIColor(colorPalette.primaryColor).isLight()! && colorPalette.primaryColor != Color(UIColor(hex: "#1ce4ac")) ? Color.black : Color.white)
        .cornerRadius(15)
        .frame(width: 300, height: 175)
        .onTapGesture {
            showArticle = true
        }
        .sheet(isPresented: $showArticle) {
            SafariView(url: URL(string: newsArticle.articleURL)!)
        }
    }
}

struct NewsArticleView_Previews: PreviewProvider {
    static var previews: some View {
        NewsArticleView(newsArticle: StockNewsArticle(language: "en", date: 1_608_239_100_000, headline: "Palantir Announces Inaugural Live Demo Day on January 26, 2021", source: "Business Wire", articleURL: "https://cloud.iexapis.com/v1/news/article/e421c573-2b1d-4a4c-ac50-60955c27c15c", related: "PLTR", imageURL: "https://cloud.iexapis.com/v1/news/image/e421c573-2b1d-4a4c-ac50-60955c27c15c"))
    }
}
