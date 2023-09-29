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
                        // custom binding
                        let isExpandedBinding = Binding<Bool>(
                            get: { viewModel.expandState[group.groupId] ?? false },
                            set: { val in viewModel.expandState[group.groupId] = val }
                        )
                        Section(isExpanded: isExpandedBinding) {
                            ForEach(group.groupItems, id: \.id) { item in
                                Text(item.name ?? "N/A")
                            }
                        } header: {
                            Text("Group \(group.groupId)")
                        }
                    }
                }
            }
            .navigationTitle("Listing")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: sortButton)
        }
        .ignoresSafeArea(edges: [.horizontal, .bottom])
    }

    var sortButton: some View {
        Button{
            viewModel.toggleOrder()
        } label: {
            Image(systemName: viewModel.imageName)
        }
    }
}

#Preview {
    ListingView()
}
