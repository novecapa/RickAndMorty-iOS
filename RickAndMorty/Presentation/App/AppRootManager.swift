//
//  AppRootManager.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 5/10/25.
//

import SwiftUI

final class AppRootManager: ObservableObject {

    @Published var currentRoot: AppRoots = .splash

    enum AppRoots {
        case splash
        case main
    }
}
