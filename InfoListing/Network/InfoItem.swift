//
//  InfoItem.swift
//  InfoListing
//
//  Created by Gefei Shen on 9/29/23.
//

import Foundation

extension NetworkManager {
    struct ListItem: Identifiable, Codable {
        var id: Int
        var listId: Int
        var name: String?
    }
}
