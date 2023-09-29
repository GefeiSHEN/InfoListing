//
//  InfoItem.swift
//  InfoListing
//
//  Created by Gefei Shen on 9/29/23.
//

import Foundation

extension NetworkManager {
    struct ListItem: Identifiable, Codable, Comparable {
        static func < (lhs: NetworkManager.ListItem, rhs: NetworkManager.ListItem) -> Bool {
            return lhs.name ?? "" < rhs.name ?? ""
        }
        
        var id: Int
        var listId: Int
        var name: String?
    }
}
