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
                if viewModel.listGroups.count < 1 {
                    loadIndicator
                } else {
                    listing
                }
            }
            .navigationTitle("Listing")
            .navigationBarTitleDisplayMode(.inline)
        }
        .ignoresSafeArea(edges: [.horizontal, .bottom])
        .alert("Network Error", isPresented: $viewModel.isError) {
            Button("Dismiss") {
                viewModel.isError = false
            }
            Button("Retry") {
                Task {
                    await viewModel.fetchList()
                }
            }
        } message: {
            Text(viewModel.error?.localizedDescription ?? "An Error Occured")
        }
    }
    
    // Button to control sort order
    var sortButton: some View {
        Button{
            viewModel.toggleOrder()
        } label: {
            Image(systemName: viewModel.imageName)
        }
    }
    
    // Loading animation
    var loadIndicator: some View {
        VStack {
            ProgressView()
            Text("Retrieving")
        }
    }

    // The actual listings
    var listing: some View {
        List {
            ForEach(viewModel.listGroups, id: \.id) { group in
                // custom binding
                let isExpandedBinding = Binding<Bool>(
                    get: { viewModel.expandState[group.id] ?? false },
                    set: { val in viewModel.expandState[group.id] = val }
                )
                Section(isExpanded: isExpandedBinding) {
                    ForEach(group.groupItems, id: \.id) { item in
                        Text(item.name ?? "N/A")
                    }
                } header: {
                    Text("Group \(group.id)")
                }
            }
        }
        .navigationBarItems(trailing: sortButton)
    }
}

#Preview {
    ListingView()
}
