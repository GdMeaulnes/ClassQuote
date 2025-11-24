//
//  MockURLProtocol.swift
//  ClassQuoteTests
//
//  Created by Richard DOUXAMI on 24/11/2025.
//
import Foundation

class MockURLProtocol: URLProtocol {

    static var response: HTTPURLResponse?
    static var responseData: Data?
    static var error: Error?

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        if let error = Self.error {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }
        if let response = Self.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        if let data = Self.responseData {
            client?.urlProtocol(self, didLoad: data)
        }
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
