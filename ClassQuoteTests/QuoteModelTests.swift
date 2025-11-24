//
//  QuoteModelTests.swift
//  ClassQuoteTests
//
//  Created by Richard DOUXAMI on 24/11/2025.
//

import Testing
import Foundation
@testable import ClassQuote

@MainActor
struct QuoteModelTests {

    @Test
    func testQuoteDecoding() throws {
        let json = """
        {
            "quoteText": "Test quote",
            "quoteAuthor": "Test Author",
            "senderName": "",
            "senderLink": "",
            "quoteLink": "http://example.com"
        }
        """.data(using: .utf8)!

        let decoded = try JSONDecoder().decode(Quote.self, from: json)

        #expect(decoded.quoteText == "Test quote")
        #expect(decoded.quoteAuthor == "Test Author")
        #expect(decoded.senderName == "")
        #expect(decoded.quoteLink == "http://example.com")
    }
}

