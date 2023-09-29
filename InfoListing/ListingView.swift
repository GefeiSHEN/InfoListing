//
//  ListingView.swift
//  InfoListing
//
//  Created by Gefei Shen on 9/29/23.
//

import SwiftUI

struct ListingView: View {
    @StateObject var viewModel = ListViewModel()
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.listGroups, id: \.id) { group in
                        Section(header: Text("Group \(group.groupId)")) {
                            ForEach(group.groupItems, id: \.id) { item in
                                Text(item.name ?? "N/A")
                            }
                        }
                    }
                }
                .padding(.top, 32)
            }
        }
        .padding(.top, 32)
        .ignoresSafeArea()
    }
}

#Preview {
    ListingView()
}
