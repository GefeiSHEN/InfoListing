//
//  MockNetworkManager.swift
//  InfoListingTests
//
//  Created by Gefei Shen on 9/29/23.
//

import Foundation
import XCTest
@testable import InfoListing

/**
    A mock of NetworkManager.
 */
class MockNetworkManager: NetworkManaging {
    var fetchListInvocationCount: Int = 0
    var fetchListResult: [InfoListing.NetworkManager.ListItem] = []
    var fetchListError: Error?
    func fetchList() async throws -> [InfoListing.NetworkManager.ListItem] {
        fetchListInvocationCount += 1
        if let error = fetchListError {
            throw error
        } 
        return fetchListResult
    }
}
