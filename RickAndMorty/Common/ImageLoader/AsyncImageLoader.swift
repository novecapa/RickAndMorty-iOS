//
//  AsyncImageLoader.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 4/10/25.
//

import SwiftUI

struct AsyncImageLoader: View {

    private enum Constants {
        static let animationDuration: CGFloat = 0.5
        static let backgroundColor: Color = .gray.opacity(0.2)
    }

    private let url: URL?
    @StateObject private var loader: ImageLoader
    @State private var isImageVisible: Bool = false
    private let placeHolder: Image?

    init(
        url: URL?,
        loader: ImageLoader = ImageLoader(),
        placeHolder: Image? = Image(.placeHolder)
    ) {
        self.url = url
        _loader = StateObject(wrappedValue: loader)
        self.placeHolder = placeHolder
    }

    var body: some View {
        Group {
            if let image = loader.image {
                image
                    .resizable()
                    .scaledToFit()
                    .opacity(isImageVisible ? 1 : 0)
                    .animation(.easeInOut(duration: Constants.animationDuration),
                               value: isImageVisible
                    )
            } else {
                ZStack {
                    if let placeHolder {
                        placeHolder
                            .resizable()
                            .scaledToFit()
                    }
                }
                .background(Constants.backgroundColor)
            }
        }
        .task {
            guard let url else { return }
            isImageVisible = false
            loader.loadImage(with: url)
        }
        .onChange(of: loader.image) {
            withAnimation(.easeInOut(duration: Constants.animationDuration)) {
                isImageVisible = loader.image != nil
            }
        }
        .onDisappear {
            loader.cancel()
        }
    }
}
