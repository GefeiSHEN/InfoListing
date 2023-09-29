//
//  ListingViewModel.swift
//  InfoListing
//
//  Created by Gefei Shen on 9/29/23.
//

import Foundation
import SwiftUI

class ListViewModel: ObservableObject {
    private var networkManager: NetworkManaging
    @Published var listItems: [NetworkManager.ListItem]

    init(networkManager: NetworkManaging = NetworkManager()) {
        self.networkManager = networkManager
        listItems = []
        Task {
            await fetchList()
        }
    }

    private func fetchList() async {
        do {
            let rawList = try await networkManager.fetchList()
            let filteredList = rawList.filter { item in
                guard let name = item.name else {
                    return false
                }
                return !name.isEmpty
            }
            DispatchQueue.main.async {
                self.listItems = filteredList
            }
        } catch {
            print(error)
            return
        }
    }
}
