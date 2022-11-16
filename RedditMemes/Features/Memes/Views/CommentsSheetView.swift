//
//  CommentsSheetView.swift
//  RedditMemes
//
//  Created by James Goodwill on 11/13/22.
//

import SwiftUI

struct CommentsSheetView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel: ViewModel = ViewModel()
    @State private var hasAppeared = false
    
    var permalink: String
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else {
                Text("\(viewModel.comments.count) \(Constants.commentsLabel)")
                    .font(FractionalFont.semibold.size(Constants.commentsLabelFontSize))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .padding(.top, Constants.commentsLabelTopPadding)
                List {
                    ForEach(viewModel.comments, id: \.id) { comment in
                        CommentView(comment: comment)
                    }
                }
                .background(.white)
                .onAppear {
                    if !hasAppeared {
                        Task {
                            await viewModel.fetchMemeComments(permalink: permalink)
                            hasAppeared = true
                        }
                    }
                }
                .alert(isPresented: $viewModel.hasError,
                       error: viewModel.error) {
                    Button(Constants.retryButtonLabel) {
                        Task {
                            await viewModel.fetchMemeComments(permalink: permalink)
                        }
                    }
                }
            }
        }
    }
}

extension CommentsSheetView {
    fileprivate enum Constants {
        static let commentsLabel = "comments"
        static let retryButtonLabel = "Retry"
        static let commentsLabelTopPadding = 14.0
        static let commentsLabelFontSize = 13.0
    }
}

struct CommentView: View {
    @Environment(\.colorScheme) var colorScheme
    let comment: ChildData
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(comment.author ?? "")
                    .font(FractionalFont.semibold.size(Constants.authorLabelFontSize))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                Text(comment.body ?? "")
                    .font(FractionalFont.regular.size(Constants.bodyLabelFontSize))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
            }
            Spacer()
            VStack {
                Image(Constants.upArrawImage)
                Text("\(comment.ups ?? 0)")
                    .font(FractionalFont.regular.size(Constants.commentsLabelFontSize))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
            }
        }
    }
}

extension CommentView {
    fileprivate enum Constants {
        static let upArrawImage = "UpArrow"
        static let authorLabelFontSize = 13.0
        static let bodyLabelFontSize = 15.0
        static let commentsLabelFontSize = 13.0
    }
}

struct CommentsSheetView_Previews: PreviewProvider {
    static var previews: some View {
        CommentsSheetView(permalink: "/r/memes/comments/yu43ze/i_trust_google_on_this/")
    }
}
