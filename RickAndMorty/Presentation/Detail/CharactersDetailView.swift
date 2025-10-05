//
//  CharactersDetailView.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 4/10/25.
//

import SwiftUI

struct CharactersDetailView: View {

    enum Constants {
        static let circleDiam: CGFloat = 20
        static let fontSize: CGFloat = 17
        static let paddingSize: CGFloat = 8
    }

    @Environment(\.dismiss) var dismiss

    private let viewModel: CharactersDetailViewModel

    init(viewModel: CharactersDetailViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            Color.customBlack
                .ignoresSafeArea()
            VStack(alignment: .leading) {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .tint(.white)
                    }
                    .padding()
                }
                AsyncImageLoader(url: viewModel.characterDetail.imageUrl)
                    .scaledToFit()
                    .background(.customBlack)
                VStack(alignment: .leading) {
                    HStack {
                        Circle()
                            .frame(width: Constants.circleDiam,
                                   height: Constants.circleDiam,
                                   alignment: .leading)
                            .foregroundColor(viewModel.characterDetail.statusColor)
                        Text(viewModel.characterDetail.status)
                            .lineLimit(1)
                            .font(.notoSans(.medium(Constants.fontSize)))
                            .foregroundColor(.white)
                    }
                    Text(viewModel.characterDetail.name)
                        .lineLimit(1)
                        .font(.notoSans(.bold(Constants.fontSize)))
                        .foregroundColor(.white)
                    if !viewModel.characterDetail.type.isEmpty {
                        Text(viewModel.characterDetail.type)
                            .lineLimit(1)
                            .font(.notoSans(.medium(Constants.fontSize)))
                            .foregroundColor(.white)
                    }
                    if !viewModel.characterDetail.species.isEmpty {
                        Text(viewModel.characterDetail.species)
                            .lineLimit(2)
                            .font(.notoSans(.medium(Constants.fontSize)))
                            .foregroundColor(.white)
                    }
                    Text(viewModel.characterDetail.gender)
                        .lineLimit(1)
                        .font(.notoSans(.medium(Constants.fontSize)))
                        .foregroundColor(.white)
                    Text(viewModel.characterDetail.appearsOn)
                        .lineLimit(1)
                        .font(.notoSans(.medium(Constants.fontSize)))
                        .foregroundColor(.white)
                }
                .padding(Constants.paddingSize)
                Spacer()
            }
        }
    }
}

#Preview {
    CharactersDetailViewBuilderMock().build()
}
