//
//  CustomProgressView.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 5/10/25.
//

import SwiftUI

struct CustomProgressView: View {

    private enum Constants {
        static let progressFrame: CGFloat = 100
        static let fontSize: CGFloat = 12
        static let cornerRadius: CGFloat = 12
        static let textPadding: CGFloat = 4
    }

    private let title: String

    init(title: String = "Loading".localized()) {
        self.title = title
    }

    var body: some View {
        ZStack {
            Color.backgroundAreaText
                .ignoresSafeArea()
            ProgressView {
                Text(title)
                    .font(.notoSans(.medium(Constants.fontSize)))
                    .foregroundStyle(.customBlack)
                    .padding(Constants.textPadding)
            }
            .progressViewStyle(CircularProgressViewStyle(tint: .customBlack))
        }
        .frame(width: Constants.progressFrame,
               height: Constants.progressFrame)
        .cornerRadius(Constants.cornerRadius)
    }
}

#Preview {
    CustomProgressView()
}
