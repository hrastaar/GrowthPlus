//
//  NewsArticleView.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/24/20.
//

import SwiftUI
import SafariServices
import URLImage

struct NewsArticleView: View {
    let newsArticle: StockNewsArticle
    @State var showArticle: Bool = false
    @ObservedObject var colorPalette: CustomColors = CustomColors.shared
    
    var body: some View {
        VStack {
            HStack {
                Text(newsArticle.source)
                    .font(Font.custom("D-DIN", size: 22.0))
                    .frame(width: 150)
            }
            .frame(height: 60)
            .padding(.horizontal)
            .padding(.top)
            Text(newsArticle.headline)
                .font(Font.custom("D-DIN", size: 18.0))
                .fontWeight(.semibold)
                .padding(.bottom)
                .padding(.horizontal)
                .frame(height: 100)
        }
        .background(colorPalette.secondaryColor)
        .foregroundColor(UIColor(colorPalette.secondaryColor).isLight()! ? Color.black : Color.white)
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
                            StockNewsArticle(date: 1608239100000,
                                             ticker: "PLTR",
                                             headline: "Palantir Announces Inaugural Live Demo Day on January 26, 2021",
                                             source: "Business Wire",
                                             articleURL: URL(string: "https://cloud.iexapis.com/v1/news/article/e421c573-2b1d-4a4c-ac50-60955c27c15c")!,
                                             related: ["PLTR"],
                                             imageURL: URL(string: "https://cloud.iexapis.com/v1/news/image/e421c573-2b1d-4a4c-ac50-60955c27c15c")!
                            )
        )
    }
}
