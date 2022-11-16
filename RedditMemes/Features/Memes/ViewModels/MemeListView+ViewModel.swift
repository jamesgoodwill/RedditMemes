//
//  MemeListView+ViewModel.swift
//  RedditMemes
//

import Foundation

extension MemeListView {
    final class ViewModel: ObservableObject {
        @Published private(set) var memes: [ChildData] = []
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
        func fetchMemes() async {
            viewState = .loading
            defer { viewState = .finished }
            
            do {
                let response = try await networkingManager.request(session: .shared,
                                                                   .meme,
                                                                   type: RedditResponse.self)
                memes = response.data.children.compactMap { $0.data }
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
