//
//  LottieView.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/19/20.
//

import Lottie
import SwiftUI

struct LottieView: UIViewRepresentable {
    typealias UIViewType = UIView
    var fileName: String
    var backgroundColor: SwiftUI.Color?
    func makeUIView(context _: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)

        let animationView = AnimationView()
        let animation = Animation.named(fileName)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.layer.cornerRadius = 15
        animationView.play()
        animationView.loopMode = .loop
        if let color = backgroundColor {
            animationView.backgroundColor = UIColor(color)
        }
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
        ])

        return view
    }

    func updateUIView(_: UIView, context _: UIViewRepresentableContext<LottieView>) {}
}
