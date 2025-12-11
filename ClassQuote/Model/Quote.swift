//
//  Quote.swift
//  ClassQuote
//
//  Created by Richard DOUXAMI on 24/11/2025.
//

import Foundation

// https://www.swiftbysundell.com/articles/customizing-codable-types-in-swift/
// https://nilcoalescing.com/blog/CodableConformanceForSwiftEnums/

// Structure basée sur la doc de l'API Forismatic
struct Quote: Decodable {
    let quoteText: String
    let quoteAuthor: String
    let senderName: String
    let senderLink: URL?
    let quoteLink: URL

    enum CodingKeys: String, CodingKey {
        case quoteText = "quoteText"
        case quoteAuthor = "quoteAuthor"
        case senderName = "senderName"
        case senderLink = "senderLink"
        case quoteLink = "quoteLink"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        quoteText = try container.decode(String.self, forKey: .quoteText)
        quoteAuthor = try container.decode(String.self, forKey: .quoteAuthor)
        senderName = try container.decode(String.self, forKey: .senderName)

        // URL optionnelle → decodeIfPresent
        senderLink = try container.decodeIfPresent(URL.self, forKey: .senderLink)

        // URL obligatoire → decode standard
        quoteLink = try container.decode(URL.self, forKey: .quoteLink)
    }
    
    init(quoteText: String, quoteAuthor: String, senderName: String, senderLink: URL?, quoteLink: URL) {
        self.quoteText = quoteText
        self.quoteAuthor = quoteAuthor
        self.senderName = senderName
        self.senderLink = senderLink
        self.quoteLink = quoteLink
    }
}

// Structure basée sur la doc de l'API d'UnSplash
struct UnSplashPhoto: Decodable {
    let blur_hash: String
    let urlsFull: URL?

    enum CodingKeys: String, CodingKey {
        case blur_hash
        case urls
    }

    enum UrlsKeys: String, CodingKey {
        case full
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        blur_hash = try container.decode(String.self, forKey: .blur_hash)

        // Sous-conteneur pour l’objet "urls"
        let urlsContainer = try container.nestedContainer(keyedBy: UrlsKeys.self, forKey: .urls)

        urlsFull = try urlsContainer.decodeIfPresent(URL.self, forKey: .full)
    }
    
    init(blur_hash: String, urlsFull: URL?) {
        self.blur_hash = blur_hash
        self.urlsFull = urlsFull
    }
}

// Structure compléte
struct DataPayLoad {
    let quote: Quote
    let photo: UnSplashPhoto
    
    init(quote: Quote, photo: UnSplashPhoto) {
        self.quote = quote
        self.photo = photo
    }
}


// Erreurs courrantes à gérer
enum APIDataSourceError: Error {
    case invalidURL
    case invalidResponse
    case noData
    case decodingError
    case downloadError
}

// Samples Quote&Photo&DataPayLoad
let  sampleQuote: Quote = .init(
    quoteText: "We should all be thankful for those people who rekindle the inner spirit. ",
    quoteAuthor: "Albert Schweitzer ",
    senderName: "",
    senderLink: URL(string: "https://example.com")!,
    quoteLink: URL(string: "http://forismatic.com/en/0555876a47/")!
)

let samplePhoto: UnSplashPhoto = .init(
    blur_hash: "LF8zMrE20f^kS$jYV@xtE2kC-oM{",
    urlsFull: URL(string: "https://images.unsplash.com/photo-1761429943764-94b69c3e9309?crop=entropy&cs=srgb&fm=jpg&ixid=M3w4MzUzMTR8MHwxfHJhbmRvbXx8fHx8fHx8fDE3NjQxODEyNzh8&ixlib=rb-4.1.0&q=85")!
)

let sampleDataPayLoad: DataPayLoad = .init(quote: sampleQuote, photo: samplePhoto)

