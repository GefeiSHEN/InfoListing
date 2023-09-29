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
        VStack {
            List(viewModel.listItems) { item in
                HStack {
                    Text("\(item.id)")
                    Spacer()
                    Text("\(item.listId)")
                    Spacer()
                    Text("\(item.name ?? "N/A")")
                }
            }
        }
        .padding(.top, 32)
        .ignoresSafeArea()
    }
}

#Preview {
    ListingView()
}
