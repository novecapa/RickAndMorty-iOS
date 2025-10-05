//
//  CharacterCellView.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 4/10/25.
//

import SwiftUI

struct CharacterCellView: View {

    enum Constants {
        static let circleDiam: CGFloat = 14
        static let fontSize: CGFloat = 16
        static let paddingSize: CGFloat = 6
    }

    private let character: Character
    private let frameSize: CGFloat
    private let onSelect: () -> Void

    init(_ character: Character,
         frameSize: CGFloat,
         onSelect: @escaping () -> Void) {
        self.character = character
        self.frameSize = frameSize
        self.onSelect = onSelect
    }

    var body: some View {
        Button {
            onSelect()
        } label: {
            VStack(alignment: .leading) {
                AsyncImageLoader(url: character.imageUrl)
                    .frame(width: frameSize, height: frameSize)
                    .scaledToFit()
                    .background(.customBlack)
                HStack {
                    Circle()
                        .frame(width: Constants.circleDiam,
                               height: Constants.circleDiam,
                               alignment: .leading)
                        .foregroundColor(character.statusColor)
                    Text(character.name)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                        .font(.notoSans(.bold(Constants.fontSize)))
                        .foregroundColor(.white)
                }
                .frame(alignment: .leading)
                .padding(.horizontal, Constants.paddingSize)
            }
            .padding(.bottom, Constants.paddingSize)
            .background(.customBlack)
        }
    }
}


#if DEBUG

#Preview {
    CharacterCellView(.mock, frameSize: 240) {}
}

#endif
