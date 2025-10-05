//
//  DismissButtonModifier.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 4/10/25.
//

import SwiftUI

public struct DismissButtonModifier: ViewModifier {

    private enum Constants {
        static let frameSize: CGFloat = 32
    }

    @Environment(\.dismiss) var dismiss

    public func body(content: Content) -> some View {
        content.toolbar {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: Constants.frameSize,
                           height: Constants.frameSize)
                    .tint(.black)
            }
        }
    }
}

public extension View {
    func addDismissButton() -> some View {
        modifier(DismissButtonModifier())
    }
}

#if DEBUG

struct DismissButtonView: View {
    var body: some View {
        Text("Dismiss Button View")
            .addDismissButton()
    }
}

#endif
