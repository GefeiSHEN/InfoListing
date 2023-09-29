//
//  NetworkManagerTest.swift
//  InfoListingTests
//
//  Created by Gefei Shen on 9/29/23.
//

import XCTest
@testable import InfoListing

class NetworkManagerTests: XCTestCase {

    var networkManager: NetworkManager!

    override func setUp() {
        super.setUp()
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let mockSession = URLSession(configuration: config)
        networkManager = NetworkManager(session: mockSession)
    }

    override func tearDown() {
        networkManager = nil
        super.tearDown()
    }

    func testFetchListSuccess() async {
        let mockData = """
        [{"id": 128, "listId": 3, "name": "Item 128"},
        {"id": 30, "listId": 1, "name": "Item 30"}]
        """.data(using: .utf8)!
        let correctList: [NetworkManager.ListItem] = [
            .init(id: 128, listId: 3, name: "Item 128"),
            .init(id: 30, listId: 1, name: "Item 30")
        ]

        let mockResponse = HTTPURLResponse(url: URL(string: "SOME.URL")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        MockURLProtocol.requestHandler = { request in
            return (mockResponse, mockData)
        }

        do {
            let list = try await networkManager.fetchList()
            XCTAssertEqual(list, correctList)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testFetchListServerError() async {
        let mockResponse = HTTPURLResponse(url: URL(string: "SOME.URL")!, statusCode: 500, httpVersion: nil, headerFields: nil)!
        MockURLProtocol.requestHandler = { request in
            return (mockResponse, Data())
        }

        do {
            _ = try await networkManager.fetchList()
            XCTFail("Expected server error")
        } catch NetworkManager.NetworkError.serverError(let statusCode) {
            XCTAssertEqual(statusCode, 500)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
