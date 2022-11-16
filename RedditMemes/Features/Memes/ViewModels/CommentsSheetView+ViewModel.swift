//
//  MemeView+ViewModel.swift
//  RedditMemes
//
//  Created by James Goodwill on 11/12/22.
//

import Foundation

import Foundation

extension CommentsSheetView {
    final class ViewModel: ObservableObject {
        @Published var comments: [ChildData] = []
        @Published private(set) var error: NetworkingManager.NetworkingError?
        @Published var hasError = false
        @Published private(set) var viewState: ViewState?
        
        private let networkingManager: NetworkingManager!
        
        var isLoading: Bool {
            viewState == .loading
        }
        
        var isFetching: Bool {
            viewState == .fetching
        }
        
        init(networkingManager: NetworkingManager = NetworkingManager.shared) {
            self.networkingManager = networkingManager
        }
        
        @MainActor
        func fetchMemeComments(permalink: String) async {
            viewState = .loading
            defer { viewState = .finished }
            
            do {
                let response = try await networkingManager.request(session: .shared,
                                                                   .comments(permalink),
                                                                   type: [RedditResponse].self)
                if !response.isEmpty && response.count > 0 {
                    comments = response[1].data.children.compactMap { $0.data }
                }
            } catch {
                self.hasError = true
                if let networkingError = error as? NetworkingManager.NetworkingError {
                    self.error = networkingError
                } else {
                    self.error = .custom(error: error)
                }
            }
        }
    }
}
