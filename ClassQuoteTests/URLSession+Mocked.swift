//
//  URLSession+Mocked.swift
//  ClassQuoteTests
//
//  Created by Richard DOUXAMI on 24/11/2025.
//
import Foundation

extension URLSession {
    static var mocked: URLSession = {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: config)
    }()
}
