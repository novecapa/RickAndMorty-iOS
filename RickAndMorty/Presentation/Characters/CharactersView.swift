//
//  CharactersView.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 4/10/25.
//

import SwiftUI

struct CharactersView: View {

    enum Constants {
        static let columnNumber: CGFloat = 2
        static let columnSpacing: CGFloat = 0
    }

    @ObservedObject var viewModel: CharactersViewModel

    private let gridItems: [GridItem] = [
        GridItem(.flexible(), spacing: Constants.columnSpacing),
        GridItem(.flexible(), spacing: Constants.columnSpacing)
    ]

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                let frameSize = geometry.size.width / Constants.columnNumber
                NavigationStack {
                    ScrollViewReader { scroll in
                        ScrollView {
                            LazyVGrid(columns: gridItems,
                                      spacing: Constants.columnSpacing) {
                                ForEach(viewModel.characters, id: \.id) { character in
                                    CharacterCellView(character, frameSize: frameSize) {
                                        viewModel.selectedCharacter = character
                                    }
                                    .onAppear {
                                        if character == viewModel.characters.last {
                                            viewModel.fetchCharacters()
                                        }
                                    }
                                }
                            }
                        }
                        .navigationTitle("Rick and Morty".localized())
                        .navigationBarTitleDisplayMode(.inline)
                        .searchable(text: $viewModel.searchText,
                                    placement: .navigationBarDrawer(displayMode: .always),
                                    prompt: "Search by name".localized())
                        .navigationBarItems(trailing: Text("\(viewModel.characters.count) \("characters".localized())")
                            .foregroundColor(.gray)
                        )
                        .onAppear {
                            viewModel.fetchCharacters()
                        }
                        .background(.backgroundAreaText)
                    }
                }
            }
            if viewModel.isLoading {
                CustomProgressView()
            }
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Error".localized()),
                  message: Text(viewModel.errorMessage),
                  dismissButton: .default(Text("OK".localized())))
        }
        .fullScreenCover(isPresented: $viewModel.showDetail) {
            viewModel.selectedCharacter = nil
        } content: {
            if let selectedCharacter = viewModel.selectedCharacter {
                CharactersDetailViewBuilder().build(character: selectedCharacter)
            }
        }
    }
}

#Preview {
    CharactersViewBuilderMock().build()
}
