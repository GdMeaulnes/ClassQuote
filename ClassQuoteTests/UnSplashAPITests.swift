//
//  UnSplashAPITests.swift
//  ClassQuoteTests
//
//  Created by Richard DOUXAMI on 28/11/2025.
//

//
//  UnSplashAPITests.swift
//  ClassQuoteTests
//

import Testing
import Foundation
@testable import ClassQuote

@Suite(.serialized)
struct UnSplashAPITests {

    // Helper : créer une instance propre de l’API
    func makeAPI() -> UnSplashAPIDataSource {
        UnSplashAPIDataSource(session: .mocked())
    }

    // MARK: - 1️⃣ Test Success

    @Test
    func testGetInfoPhotoSuccess() async throws {
        await MockURLProtocol.store.reset()

        let json = """
        {
          "blur_hash": "AAAA",
          "urlsFull": "https://example.com/full.jpg"
        }
        """.data(using: .utf8)!

        let response = HTTPURLResponse(
            url: URL(string: "https://api.unsplash.com/photos/random")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )

        await MockURLProtocol.store.setData(json)
        await MockURLProtocol.store.setResponse(response)
        await MockURLProtocol.store.setError(nil)

        let api = makeAPI()
        let photo = try await api.getInfoPhoto()

        #expect(photo.blur_hash == "AAAA")
        #expect(photo.urlsFull == URL(string: "https://example.com/full.jpg")!)
    }

    // MARK: - 2️⃣ Test Invalid HTTP response (ex: 500)

    @Test
    func testInvalidStatusCode() async throws {
        await MockURLProtocol.store.reset()

        let response = HTTPURLResponse(
            url: URL(string: "https://api.unsplash.com/photos/random")!,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil
        )

        await MockURLProtocol.store.setResponse(response)
        await MockURLProtocol.store.setData(Data())
        await MockURLProtocol.store.setError(nil)

        let api = makeAPI()

        await #expect(throws: UnSplashAPIDataSourceError.invalidResponse) {
            _ = try await api.getInfoPhoto()
        }
    }

    // MARK: - 3️⃣ Test No Data (erreur réseau)

    @Test
    func testNoData() async throws {
        await MockURLProtocol.store.reset()

        await MockURLProtocol.store.setError(URLError(.notConnectedToInternet))
        await MockURLProtocol.store.setResponse(nil)
        await MockURLProtocol.store.setData(nil)

        let api = makeAPI()

        await #expect(throws: UnSplashAPIDataSourceError.noData) {
            _ = try await api.getInfoPhoto()
        }
    }

    // MARK: - 4️⃣ Test Decoding Error

    @Test
    func testDecodingError() async throws {
        await MockURLProtocol.store.reset()

        let invalidJSON = "{INVALID}".data(using: .utf8)!

        let response = HTTPURLResponse(
            url: URL(string: "https://api.unsplash.com/photos/random")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )

        await MockURLProtocol.store.setResponse(response)
        await MockURLProtocol.store.setData(invalidJSON)
        await MockURLProtocol.store.setError(nil)

        let api = makeAPI()

        await #expect(throws: UnSplashAPIDataSourceError.decodingError) {
            _ = try await api.getInfoPhoto()
        }
    }
}
