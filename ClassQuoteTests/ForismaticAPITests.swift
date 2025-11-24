//
//  ForismaticAPITests.swift
//  ClassQuoteTests
//
//  Created by Richard DOUXAMI on 24/11/2025.
//

import Testing
import Foundation
@testable import ClassQuote

@MainActor
struct ForismaticAPITests {

    @Test
    func testGetQuoteSuccess() async throws {
        // JSON valide
        let json = """
        {
            "quoteText": "Hello",
            "quoteAuthor": "Tester",
            "senderName": "",
            "senderLink": "",
            "quoteLink": "http://example.com"
        }
        """.data(using: .utf8)!

        MockURLProtocol.responseData = json
        MockURLProtocol.response = HTTPURLResponse(
            url: URL(string: "http://example.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )

        let api = ForismaticAPIDataSource(session: .mocked)
        let quote = try await api.getQuote()

        #expect(quote.quoteText == "Hello")
        #expect(quote.quoteAuthor == "Tester")
        #expect(quote.quoteLink == "http://example.com")
    }

    @Test
    func testGetQuoteInvalidResponse() async throws {
        MockURLProtocol.responseData = Data()
        MockURLProtocol.response = HTTPURLResponse(
            url: URL(string: "http://example.com")!,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil
        )

        let api = ForismaticAPIDataSource(session: .mocked)

        await #expect(throws: ForismaticAPIDataSourceError.invalidResponse) {
            _ = try await api.getQuote()
        }
    }

    @Test
    func testGetQuoteNoData() async throws {
        MockURLProtocol.error = URLError(.notConnectedToInternet)
        MockURLProtocol.responseData = nil
        MockURLProtocol.response = nil

        let api = ForismaticAPIDataSource(session: .mocked)

        await #expect(throws: ForismaticAPIDataSourceError.noData) {
            _ = try await api.getQuote()
        }
    }

    @Test
    func testGetQuoteDecodingError() async throws {
        let invalidJSON = "{invalid}".data(using: .utf8)!

        MockURLProtocol.responseData = invalidJSON
        MockURLProtocol.response = HTTPURLResponse(
            url: URL(string: "http://example.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )

        let api = ForismaticAPIDataSource(session: .mocked)

        await #expect(throws: ForismaticAPIDataSourceError.decodingError) {
            _ = try await api.getQuote()
        }
    }
}
