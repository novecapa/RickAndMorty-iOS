//
//  ImageLoader.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 4/10/25.
//

import SwiftUI
import Foundation
import CryptoKit

final class ImageLoader: ObservableObject {

    private enum Constants {
        static let imageCacheFolder: String = "ImageCache"
    }

    @Published var image: Image?
    private var imageURL: URL?
    private var currentTask: Task<Void, Never>?

    private let fileManager = FileManager.default
    private let cacheDirectory: URL? = {
        FileManager.default.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        ).first?.appendingPathComponent(Constants.imageCacheFolder)
    }()

    init() {
        self.createCacheDirectoryIfNeeded()
    }

    func loadImage(with url: URL) {
        imageURL = url
        currentTask?.cancel()

        if let cachedImage = loadImageFromDisk(url: url) {
            DispatchQueue.main.async { [weak self] in
                self?.image = cachedImage
            }
            return
        }

        currentTask = Task { [weak self] in
            guard let self = self else { return }
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                guard !Task.isCancelled, self.imageURL == url,
                      let downloadedImage = UIImage(data: data) else { return }
                self.saveImageToDisk(data: data, url: url)
                await MainActor.run {
                    self.image = Image(uiImage: downloadedImage)
                }
            } catch is CancellationError {
                // Task cancelled
            } catch {
                // Log error
            }
            self.currentTask = nil
        }
    }

    func cancel() {
        currentTask?.cancel()
        currentTask = nil
    }
}

// MARK: Image cache methods

private extension ImageLoader {
    func createCacheDirectoryIfNeeded() {
        guard let cacheDirectory else { return }
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(
                at: cacheDirectory,
                withIntermediateDirectories: true
            )
        }
    }

    func cacheFileURL(for url: URL) -> URL? {
        guard let cacheDirectory else { return nil }
        let digest = SHA256.hash(data: Data(url.absoluteString.utf8))
        let filename = digest.compactMap { String(format: "%02x", $0) }.joined()
        return cacheDirectory.appendingPathComponent(filename)
    }

    func saveImageToDisk(data: Data, url: URL) {
        guard let fileURL = cacheFileURL(for: url) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }

    func loadImageFromDisk(url: URL) -> Image? {
        guard let fileURL = cacheFileURL(for: url) else { return nil }
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        if let img = UIImage(data: data) {
            return Image(uiImage: img)
        }
        return nil
    }
}
