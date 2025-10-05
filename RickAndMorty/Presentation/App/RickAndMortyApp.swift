//
//  RickAndMortyApp.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 3/10/25.
//

import SwiftUI

@main
struct RickAndMortyApp: App {

    // Register app root manager
    @StateObject var appRootManager = AppRootManager()

    var body: some Scene {
        WindowGroup {
            Group {
                switch appRootManager.currentRoot {
                case .splash:
                    SplashView()
                case .main:
                    CharactersViewBuilder().build()
                }
            }
            .environmentObject(appRootManager)
        }
    }
}
