//
//  RotationAnimationView.swift
//  RedditMemes
//
//  Created by James Goodwill on 11/16/22.
//

import SwiftUI

struct RotationAnimationView: View {
    @State private var isRotating = 0.0
    
    var body: some View {
        Image(Constants.spinnerImage)
            .rotationEffect(.degrees(isRotating))
            .onAppear {
                withAnimation(.linear(duration: 1)
                    .speed(0.5).repeatForever(autoreverses: false)) {
                        isRotating = 360.0
                    }
            }
    }
}

extension RotationAnimationView {
    fileprivate enum Constants {
        static let spinnerImage = "icon"
    }
}
