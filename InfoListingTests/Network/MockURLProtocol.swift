//
//  MockURLProtocol.swift
//  InfoListingTests
//
//  Created by Gefei Shen on 9/29/23.
//

import Foundation

// Adapted from https://theiosdude.medium.com/urlsession-stubbing-network-responses-for-unit-tests-a8bc572739f5

/**
    A mock of URLProtocol for testing.
 */
class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) -> (HTTPURLResponse, Data))?
    override class func canInit(with request: URLRequest) -> Bool { return true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { return request }
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else { return }
        let (response, data) = handler(request)
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: data)
        client?.urlProtocolDidFinishLoading(self)
    }
    override func stopLoading() {}
}
