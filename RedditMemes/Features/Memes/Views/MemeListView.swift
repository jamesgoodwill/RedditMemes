//
//  MemeListView.swift
//  RedditMemes
//

import SwiftUI

struct MemeListView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel: ViewModel = ViewModel()
    @State private var hasAppeared = false
    
    private let columns = Array(repeating: GridItem(.flexible()), count: Constants.columnCount)
    
    var body: some View {
        VStack {
            VStack {
                Text(Constants.title)
                    .font(FractionalFont.semibold.size(Constants.titleFontSize))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
            }
            ZStack {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVGrid(columns: columns, spacing: Constants.gridSpacing) {
                            ForEach(viewModel.memes, id: \.id) { meme in
                                MemeView(meme: meme)
                            }
                        }
                    }
                    .refreshable {
                        if !viewModel.isLoading {
                            await viewModel.fetchMemes()
                        }
                    }
                    .overlay(alignment: .bottom) {
                        if viewModel.isFetching {
                            ProgressView()
                        }
                    }
                    .onAppear {
                        if !hasAppeared {
                            Task {
                                await viewModel.fetchMemes()
                                hasAppeared = true
                            }
                        }
                    }
                    .alert(isPresented: $viewModel.hasError,
                           error: viewModel.error) {
                        Button(Constants.retryLabel) {
                            Task {
                                await viewModel.fetchMemes()
                            }
                        }
                    }
                }
            }
        }
    }
}

extension MemeListView {
    fileprivate enum Constants {
        static let title = "r/Memes"
        static let retryLabel = "Retry"
        static let titleFontSize = 18.0
        static let gridSpacing = 16.0
        static let columnCount = 1
    }
}

struct MemeListView_Previews: PreviewProvider {
    static var previews: some View {
        MemeListView()
    }
}
