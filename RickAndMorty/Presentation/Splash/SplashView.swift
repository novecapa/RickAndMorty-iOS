//
//  SplashView.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 5/10/25.
//

import SwiftUI

struct SplashView: View {

    private enum Constants {
        static let sizeFrame: CGFloat = 250
        static let duration: Double = 3
    }

    @EnvironmentObject private var appRootManager: AppRootManager

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            Image(.splashIcon)
                .resizable()
                .scaledToFit()
                .frame(width: Constants.sizeFrame,
                       height: Constants.sizeFrame)
        }
        .onAppear {
            Task {
                try? await Task.sleep(for: .seconds(Constants.duration))
                withAnimation(.easeOut) {
                    appRootManager.currentRoot = .main
                }
            }
        }
    }
}

#Preview {
    SplashView()
}
