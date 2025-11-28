//
//  Quote.swift
//  ClassQuote
//
//  Created by Richard DOUXAMI on 24/11/2025.
//

import Foundation

// https://www.swiftbysundell.com/articles/customizing-codable-types-in-swift/
// https://nilcoalescing.com/blog/CodableConformanceForSwiftEnums/

// 1. Récupération du JSON
// "senderLink": "",

// 2.

// Structure basée sur la doc de l'API Forismatic
struct Quote: Codable {
    let quoteText: String
    let quoteAuthor: String
    let senderName: String
    let senderLink: URL?
    let quoteLink: URL
    
    init(
        quoteText: String,
        quoteAuthor: String,
        senderName: String,
        senderLink: URL,
        quoteLink: URL
    ) {
        self.quoteText = quoteText
        self.quoteAuthor = quoteAuthor
        self.senderName = senderName
        self.senderLink = senderLink
        self.quoteLink = quoteLink
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawData = try container.decode([String: String].self)
        
        guard let quoteText = rawData["quoteText"],
              let quoteAuthor = rawData["quoteAuthor"],
              let senderName = rawData["senderName"],
              let senderLinkRawData = rawData["senderLink"],
              let quoteLinkRawData = rawData["quoteLink"] else {
            fatalError("")
        }
        
        self.quoteText = quoteText
        self.quoteAuthor = quoteAuthor
        self.senderName = senderName
        self.senderLink = URL(string: senderLinkRawData)
        self.quoteLink = URL(string: quoteLinkRawData)!
    }
}

// Structure basée sur la doc de UnSplash
struct UnsplashPhoto: Codable {
    let blur_hash: String
    let urlsFull: URL
}

// Samples quote&Photo
let  sampleQuote: Quote = .init(
    quoteText: "We should all be thankful for those people who rekindle the inner spirit. ",
    quoteAuthor: "Albert Schweitzer ",
    senderName: "",
    senderLink: URL(string: "https://example.com")!,
    quoteLink: URL(string: "http://forismatic.com/en/0555876a47/")!
)

let samplePhoto: UnsplashPhoto = .init(
    blur_hash: "LF8zMrE20f^kS$jYV@xtE2kC-oM{",
    urlsFull: URL(string: "https://images.unsplash.com/photo-1761429943764-94b69c3e9309?crop=entropy&cs=srgb&fm=jpg&ixid=M3w4MzUzMTR8MHwxfHJhbmRvbXx8fHx8fHx8fDE3NjQxODEyNzh8&ixlib=rb-4.1.0&q=85")!
)
