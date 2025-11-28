//
//  UnSplashAPIDataSource.swift
//  ClassQuote
//
//  Created by Richard DOUXAMI on 26/11/2025.
//

import Foundation

// Erreurs courrantes à gérer
// DRY : Don't Repeat Yourself
enum UnSplashAPIDataSourceError: Error {
    case invalidURL
    case invalidResponse
    case noData
    case decodingError
}

// Interface avec l'API d'UnSplash
class UnSplashAPIDataSource {

    let session: URLSession
    var baseURL: URL {
        URL(string: "https://api.unsplash.com/photos/random/?client_id=YTnimpBsVVMoE8V3wMsSpz4a4TE68vbwCctRzm7UFCY")!
    }

    init(session: URLSession = .shared) {
        self.session = session
    }

    func getInfoPhoto() async throws -> UnsplashPhoto {
        guard let (data, response) = try? await session.data(from: baseURL) else {
            throw UnSplashAPIDataSourceError.noData
        }

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw UnSplashAPIDataSourceError.invalidResponse
        }

        do {
            return try JSONDecoder().decode(UnsplashPhoto.self, from: data)
        } catch {
            throw UnSplashAPIDataSourceError.decodingError
        }
    }
}
