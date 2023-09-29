//
//  ListingViewModel.swift
//  InfoListing
//
//  Created by Gefei Shen on 9/29/23.
//

import Foundation
import SwiftUI

class ListViewModel: ObservableObject {
    typealias ListItem = NetworkManager.ListItem
    private var networkManager: NetworkManaging
    @Published var listGroups: [ListGroup]

    init(networkManager: NetworkManaging = NetworkManager()) {
        self.networkManager = networkManager
        listGroups = []
        Task {
            await fetchList()
        }
    }

    private func fetchList() async {
        do {
            let rawList = try await networkManager.fetchList()
            DispatchQueue.main.async {
                self.listGroups = self.processList(rawList)
            }
        } catch {
            print(error)
            return
        }
    }

    private func processList(_ rawList: [ListItem]) -> [ListGroup] {
        // Clear entires with empty or nil names
        let filteredList = rawList.filter { item in
            guard let name = item.name else {
                return false
            }
            return !name.isEmpty
        }
        //sort by group id and group item values
        var listGroups: [ListGroup] = []
        let groupedItems = Dictionary(grouping: filteredList, by: { $0.listId })

        for (key, value) in groupedItems {
            let listGroup = ListGroup(groupId: key, groupItems: value.sorted())
            listGroups.append(listGroup)
        }

        return listGroups.sorted()
    }
}

extension ListViewModel {
    struct ListGroup: Identifiable, Comparable {
        static func < (lhs: ListViewModel.ListGroup, rhs: ListViewModel.ListGroup) -> Bool {
            lhs.groupId < rhs.groupId
        }
        
        static func == (lhs: ListViewModel.ListGroup, rhs: ListViewModel.ListGroup) -> Bool {
            return lhs.id == rhs.id
        }
        
        var id = UUID()
        var groupId: Int
        var groupItems: [ListItem]
    }
}
