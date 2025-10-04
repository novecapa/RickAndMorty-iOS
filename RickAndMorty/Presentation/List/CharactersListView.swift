//
//  CharactersListView.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 4/10/25.
//

import SwiftUI

struct CharactersListView: View {

    enum Constants {
        static let columnNumber: CGFloat = 2
        static let columnSpacing: CGFloat = 0
    }

    @ObservedObject var viewModel: CharactersListViewModel

    private let gridItems: [GridItem] = [
        GridItem(.flexible(), spacing: Constants.columnSpacing),
        GridItem(.flexible(), spacing: Constants.columnSpacing)
    ]

    var body: some View {
        ZStack {
            GeometryReader { geometry in
            }
        }
    }
}

#Preview {
    CharactersListViewBuilder().build()
}
