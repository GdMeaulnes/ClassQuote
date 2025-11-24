//
//  Quote.swift
//  ClassQuote
//
//  Created by Richard DOUXAMI on 24/11/2025.
//

import Foundation

// Structure basée sur la doc de l'API 
struct Quote: Codable {
    let quoteText : String
    let quoteAuthor: String
    let senderName : String
    let senderLink : String
    let quoteLink : String
}

// Sample quote
let  sampleQuote: Quote = .init(quoteText: "We should all be thankful for those people who rekindle the inner spirit. ",
                                quoteAuthor: "Albert Schweitzer ",
                                senderName: "",
                                senderLink: "",
                                quoteLink: "http://forismatic.com/en/0555876a47/")

