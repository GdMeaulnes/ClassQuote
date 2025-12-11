//
//  ForismaticAPIDataSource.swift
//  ClassQuote
//
//  Created by Richard DOUXAMI on 24/11/2025.
//

import Foundation

// Interface avec l'API de Forismatic
class ForismaticAPIDataSource {

    let session: URLSession
    var baseURL: URL {
        URL(string: "http://api.forismatic.com/api/1.0/?method=getQuote&format=json&lang=en")!
    }

    init(session: URLSession = .shared) {
        self.session = session
    }

    // Récupération de la pensée du jour
    func getQuote() async throws -> Quote {
        guard let (data, response) = try? await session.data(from: baseURL) else {
            throw APIDataSourceError.noData
        }

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw APIDataSourceError.invalidResponse
        }

        do {
            return try JSONDecoder().decode(Quote.self, from: data)
        } catch {
            throw APIDataSourceError.decodingError
        }
    }
}

