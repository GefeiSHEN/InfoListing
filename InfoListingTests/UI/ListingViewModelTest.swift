//
//  ListingViewModelTest.swift
//  InfoListingTests
//
//  Created by Gefei Shen on 9/29/23.
//

import XCTest
import Combine
@testable import InfoListing

@MainActor
class ListViewModelTests: XCTestCase {

    var sut: ListViewModel!
    var mockNetworkManager: MockNetworkManager!
    var cancellable: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        cancellable = .init()
        sut = ListViewModel(networkManager: mockNetworkManager)
    }

    override func tearDown() {
        sut = nil
        mockNetworkManager = nil
        cancellable = nil
        super.tearDown()
    }
    
    func test_setup() {
        XCTAssertEqual(sut.listGroups, [])
        XCTAssertEqual(sut.expandState, [:])
        XCTAssertTrue(sut.isAscending)
        XCTAssertFalse(sut.isError)
        XCTAssertNil(sut.error)
    }

    func test_fetchList_success() async {
        let mockListItems: [NetworkManager.ListItem] = [.init(id: 1, listId: 1, name: "Item 1")]
        mockNetworkManager.fetchListResult = mockListItems

        let exp = expectation(description: "Fetch List")

        sut.$listGroups
            .first(where: { !$0.isEmpty })
            .sink { _ in
                exp.fulfill()
            }
            .store(in: &cancellable)

        await sut.fetchList()

        await fulfillment(of: [exp], timeout: 1)

        XCTAssertFalse(sut.listGroups.isEmpty)
        XCTAssertEqual(sut.expandState[1], true)
        XCTAssertFalse(sut.isError)
        XCTAssertNil(sut.error)
    }

    func test_fetchList_failure() async {
        let mockError = NetworkManager.NetworkError.invalidURL
        mockNetworkManager.fetchListError = mockError

        let exp = expectation(description: "Fetch List Failure")

        sut.$isError
            .first(where: { $0 == true})
            .sink { _ in
                exp.fulfill()
            }
            .store(in: &cancellable)

        await sut.fetchList()

        await fulfillment(of: [exp], timeout: 1)

        XCTAssertTrue(sut.isError)
        let networkError = try? XCTUnwrap(sut.error as? NetworkManager.NetworkError)
        XCTAssertEqual(networkError, mockError)
        XCTAssertTrue(sut.listGroups.isEmpty)
    }

    func test_list_grouping() async {
        let mockListItems: [NetworkManager.ListItem] = [
            .init(id: 1, listId: 1, name: "Item 1"),
            .init(id: 2, listId: 2, name: "Item 2"),
            .init(id: 3, listId: 1, name: "Item 3")
        ]
        let correctGroups: [ListViewModel.ListGroup] = [
            .init(id: 1, groupItems: [
                .init(id: 1, listId: 1, name: "Item 1"),
                .init(id: 3, listId: 1, name: "Item 3")
            ]),
            .init(id: 2, groupItems: [
                .init(id: 2, listId: 2, name: "Item 2")
            ])
        ]
        mockNetworkManager.fetchListResult = mockListItems

        let exp = expectation(description: "Fetch List")

        sut.$listGroups
            .first(where: { !$0.isEmpty })
            .sink { _ in
                exp.fulfill()
            }
            .store(in: &cancellable)

        await sut.fetchList()

        await fulfillment(of: [exp], timeout: 1)

        XCTAssertNil(sut.error)
        XCTAssertFalse(sut.isError)
        XCTAssertEqual(sut.listGroups, correctGroups)
    }

    func test_list_grouping_withEmptyAndNil() async {
        let mockListItems: [NetworkManager.ListItem] = [
            .init(id: 1, listId: 1, name: "Item 1"),
            .init(id: 2, listId: 2, name: "Item 2"),
            .init(id: 3, listId: 1, name: "Item 3"),
            .init(id: 4, listId: 1, name: ""),
            .init(id: 5, listId: 2, name: nil)
        ]
        let correctGroups: [ListViewModel.ListGroup] = [
            .init(id: 1, groupItems: [
                .init(id: 1, listId: 1, name: "Item 1"),
                .init(id: 3, listId: 1, name: "Item 3")
            ]),
            .init(id: 2, groupItems: [
                .init(id: 2, listId: 2, name: "Item 2")
            ])
        ]
        mockNetworkManager.fetchListResult = mockListItems

        let exp = expectation(description: "Fetch List")

        sut.$listGroups
            .first(where: { !$0.isEmpty })
            .sink { _ in
                exp.fulfill()
            }
            .store(in: &cancellable)

        await sut.fetchList()

        await fulfillment(of: [exp], timeout: 1)

        XCTAssertNil(sut.error)
        XCTAssertFalse(sut.isError)
        XCTAssertEqual(sut.listGroups, correctGroups)
    }

    func test_toggle_order() async {
        let mockListItems: [NetworkManager.ListItem] = [
            .init(id: 1, listId: 1, name: "Item 1"),
            .init(id: 2, listId: 2, name: "Item 2"),
            .init(id: 3, listId: 1, name: "Item 3")
        ]
        let correctGroups: [ListViewModel.ListGroup] = [
            .init(id: 2, groupItems: [
                .init(id: 2, listId: 2, name: "Item 2")
            ]),
            .init(id: 1, groupItems: [
                .init(id: 3, listId: 1, name: "Item 3"),
                .init(id: 1, listId: 1, name: "Item 1")
            ])
        ]
        mockNetworkManager.fetchListResult = mockListItems

        let exp = expectation(description: "Fetch List")

        sut.$listGroups
            .first(where: { !$0.isEmpty }) // Skip the initial value
            .sink { _ in
                exp.fulfill()
            }
            .store(in: &cancellable)

        await sut.fetchList()

        await fulfillment(of: [exp], timeout: 1)
        sut.toggleOrder()

        XCTAssertNil(sut.error)
        XCTAssertFalse(sut.isAscending)
        XCTAssertEqual(sut.imageName, "arrow.down.square")
        XCTAssertEqual(sut.listGroups, correctGroups)
    }
}
