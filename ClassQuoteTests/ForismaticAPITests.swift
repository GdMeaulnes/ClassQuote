//
//  ForismaticAPITests.swift
//  ClassQuoteTests
//
//  Created by Richard DOUXAMI on 24/11/2025.
//

import Testing
import Foundation
@testable import ClassQuote

@Suite(.serialized)
struct ForismaticAPITests {

    // MARK: - SUCCESS

    @Test
    func testGetQuoteSuccess() async throws {

        await MockURLProtocol.store.reset()

        let json = """
        {
            "quoteText": "Hello",
            "quoteAuthor": "Tester",
            "senderName": "",
            "senderLink": "",
            "quoteLink": "http://example.com"
        }
        """.data(using: .utf8)!

        await MockURLProtocol.store.setData(json)
        await MockURLProtocol.store.setResponse(
            HTTPURLResponse(
                url: URL(string: "http://example.com")!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )
        )
        await MockURLProtocol.store.setError(nil)

        let api = await ForismaticAPIDataSource(session: .mocked())
        let quote = try await api.getQuote()

        #expect(quote.quoteText == "Hello")
        #expect(quote.quoteAuthor == "Tester")
        #expect(quote.quoteLink == URL(string: "http://example.com"))
    }

    // MARK: - INVALID RESPONSE (ex: 500)

    @Test
    func testGetQuoteInvalidResponse() async throws {

        await MockURLProtocol.store.reset()

        let json = """
        {
            "quoteText": "Hello",
            "quoteAuthor": "Tester",
            "senderName": "",
            "senderLink": "",
            "quoteLink": "http://example.com"
        }
        """.data(using: .utf8)!

        await MockURLProtocol.store.setData(json)
        await MockURLProtocol.store.setResponse(
            HTTPURLResponse(
                url: URL(string: "http://example.com")!,
                statusCode: 500,
                httpVersion: nil,
                headerFields: nil
            )
        )
        await MockURLProtocol.store.setError(nil)

        let api = await ForismaticAPIDataSource(session: .mocked())

        await #expect(throws: ForismaticAPIDataSourceError.invalidResponse) {
            _ = try await api.getQuote()
        }
    }

    // MARK: - NO DATA (erreur réseau)

    @Test
    func testGetQuoteNoData() async throws {

        await MockURLProtocol.store.reset()

        await MockURLProtocol.store.setError(URLError(.notConnectedToInternet))
        await MockURLProtocol.store.setData(nil)
        await MockURLProtocol.store.setResponse(nil)

        let api = await ForismaticAPIDataSource(session: .mocked())

        await #expect(throws: ForismaticAPIDataSourceError.noData) {
            _ = try await api.getQuote()
        }
    }

    // MARK: - DECODING ERROR

    @Test
    func testGetQuoteDecodingError() async throws {

        await MockURLProtocol.store.reset()

        let invalidJSON = "{invalid}".data(using: .utf8)!

        await MockURLProtocol.store.setData(invalidJSON)
        await MockURLProtocol.store.setResponse(
            HTTPURLResponse(
                url: URL(string: "http://example.com")!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )
        )
        await MockURLProtocol.store.setError(nil)

        let api = await ForismaticAPIDataSource(session: .mocked())

        await #expect(throws: ForismaticAPIDataSourceError.decodingError) {
            _ = try await api.getQuote()
        }
    }
}
