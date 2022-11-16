//
//  MemeView.swift
//  RedditMemes
//

import SwiftUI
import Kingfisher

struct MemeView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var shouldShowComments: Bool = false
    @State var showShareSheet: Bool = false
    
    let meme: ChildData
    
    var body: some View {
        ZStack {
            VStack {
                KFImage.url(URL(string: meme.url ?? Constants.fallbackImage))
                    .fade(duration: Constants.imageFadeDuration)
                    .cacheMemoryOnly()
                    .resizable()
                    .placeholder {
                        RotationAnimationView()
                    }
                    .scaledToFit()
                    .padding(.top, Constants.imageTopPadding)
                HStack {
                    Text("u/\(meme.author ?? "")")
                        .frame(alignment: .leading)
                        .font(FractionalFont.regular.size(Constants.authorFontSize))
                        .foregroundColor(.white)
                        .padding(.leading, Constants.authorPaddingLeading)
                    Spacer()
                }
                HStack {
                    Text(meme.title ?? "")
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(nil)
                        .multilineTextAlignment(.leading)
                        .font(FractionalFont.regular.size(Constants.titleFontSize))
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .padding(.leading, Constants.titlePaddingLeading)
                    Spacer()
                }
            }
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    ActionButtonsView
                }
            }
            .padding(.trailing, Constants.zstackPadding)
        }
        .frame(width: UIScreen.main.bounds.size.width)
        .sheet(isPresented: $shouldShowComments) {
            CommentsSheetView(permalink: meme.permalink ?? "")
        }
    }
    
    @ViewBuilder
    private var ActionButtonsView: some View {
        VStack {
            VStack {
                Button(
                    action: {
                        print("Do an up if time!")
                    },
                    label: {
                        Image(Constants.upArrowImage)
                    }
                )
                Text("\(meme.ups ?? 0)")
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .font(FractionalFont.semibold.size(Constants.actionButtonLabelFontSize))
            }
            VStack {
                Button(
                    action: {
                        shouldShowComments = true
                    },
                    label: {
                        Image(Constants.messageImage)
                    }
                )
                Text("\(meme.numComments ?? 0)")
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .font(FractionalFont.semibold.size(Constants.actionButtonLabelFontSize))
            }
            VStack {
                Button(
                    action: {
                        showShareSheet = true
                    },
                    label: {
                        Image(Constants.shareIconImage)
                    }
                )
                Text(Constants.shareLabel)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .font(FractionalFont.semibold.size(Constants.actionButtonLabelFontSize))
            }
        }
        .padding()
        .shadow(
            color: .black,
            radius: Constants.actionButtonShadowRadius,
            x: Constants.actionButtonShadowX,
            y: Constants.actionButtonShadowY
        )
        .cornerRadius(Constants.actionsButtonCornerRadius)
        .sheet(isPresented: $showShareSheet) {
            if let title = meme.title, let urlString = meme.url, let url = URL(string: urlString) {
                ShareSheet(activityItems: [title, url])
            }
        }
    }
}

extension MemeView {
    fileprivate enum Constants {
        static let fallbackImage = "https://bookface-images.s3.amazonaws.com/small_logos/bff84d941531b490bf65bb53c051ef24de72d746.png"
        static let retryLabel = "Retry"
        static let upArrowImage = "Union"
        static let messageImage = "MessageIcon"
        static let shareIconImage = "ShareIcon"
        static let shareLabel = "Share"
        static let imageFadeDuration = 0.25
        static let imageTopPadding = 44.0
        static let authorFontSize = 17.0
        static let authorPaddingLeading = 16.0
        static let titlePaddingLeading = 16.0
        static let titleFontSize = 16.0
        static let zstackPadding = 16.0
        static let actionButtonLabelFontSize = 13.0
        static let actionButtonShadowRadius = 8.0
        static let actionButtonShadowX = 0.0
        static let actionButtonShadowY = 5.0
        static let actionsButtonCornerRadius = 5.0
    }
}

struct MemeView_Previews: PreviewProvider {
    static var previews: some View {
        MemeView(
            shouldShowComments: false,
            meme: ChildData(
                id: "1",
                author: "author",
                title: "Let us explain \"Rule 8: No Reposts\"",
                body: "This is a sample body",
                ups: 18191,
                numComments: 32,
                url: "https://i.redd.it/svhda4sj07q91.jpg",
                permalink: "/r/memes/comments/yu43ze/i_trust_google_on_this/"
            )
        )
    }
}
