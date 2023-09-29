//
//  NetworkManager.swift
//  InfoListing
//
//  Created by Gefei Shen on 9/29/23.
//

import Foundation

protocol NetworkManaging {
    func fetchContent() async throws -> [NetworkManager.ListItem]
}

class NetworkManager: NetworkManaging {
    var session : URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    func fetchContent() async throws -> [ListItem] {
        guard let url = URL(string: "https://fetch-hiring.s3.amazonaws.com/hiring.json") else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown
        }
        guard httpResponse.statusCode == 200 else {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }

        var meals = [ListItem]()
        meals = try JSONDecoder().decode([ListItem].self, from: data)

        return meals
    }
}

extension NetworkManager {
    enum NetworkError: Error {
        case invalidURL
        case serverError(statusCode: Int)
        case unknown
    }
}
