//
//  UnSplashAPIDataSource.swift
//  ClassQuote
//
//  Created by Richard DOUXAMI on 26/11/2025.
//

import Foundation

// Interface avec l'API d'UnSplash
class UnSplashAPIDataSource {
    
    let session: URLSession
    var baseURL: URL {
        URL(string: "https://api.unsplash.com/photos/random/?client_id=YTnimpBsVVMoE8V3wMsSpz4a4TE68vbwCctRzm7UFCY")!
    }
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getInfoPhoto() async throws -> UnSplashPhoto {
        guard let (data, response) = try? await session.data(from: baseURL) else {
            throw APIDataSourceError.noData
        }
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw APIDataSourceError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(UnSplashPhoto.self, from: data)
        } catch {
            throw APIDataSourceError.decodingError
        }
    }
    
    func downloadImage(from url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return data
    }
}
