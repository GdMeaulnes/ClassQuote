//
//  MockURLProtocol.swift
//  ClassQuoteTests
//
//  Created by Richard DOUXAMI on 24/11/2025.
//
import Foundation

actor MockStore {
    var response: HTTPURLResponse?
    var responseData: Data?
    var error: Error?

    func reset() {
        response = nil
        responseData = nil
        error = nil
    }
    
    func setResponse(_ response: HTTPURLResponse?) {
        self.response = response
    }

    func setData(_ data: Data?) {
        self.responseData = data
    }

    func setError(_ error: Error?) {
        self.error = error
    }
}

class MockURLProtocol: URLProtocol {

    static let store = MockStore()

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {

        Task {
            // On lit tout depuis l’actor pour éviter les concurences
            let error = await Self.store.error
            let response = await Self.store.response
            let data = await Self.store.responseData

            if let error {
                client?.urlProtocol(self, didFailWithError: error)
                return
            }

            if let response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }

            if let data {
                client?.urlProtocol(self, didLoad: data)
            }

            client?.urlProtocolDidFinishLoading(self)
        }
    }

    override func stopLoading() {}
}
