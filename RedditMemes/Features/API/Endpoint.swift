//
//  Endpoint.swift
//  RedditMemes
//

import Foundation

enum Endpoint {
    case meme
    case comments(String)
}

extension Endpoint {
    enum MethodType: Equatable {
        case GET
        case POST(data: Data?)
    }
}

extension Endpoint {
    
    var host: String { "www.reddit.com" }
    
    var path: String {
        switch self {
        case .meme:
            return "/r/memes.json"
        case .comments(let permalink):
            return "\(permalink).json"
        }
    }
    
    var methodType: MethodType {
        switch self {
        case .meme,
                .comments:
            return .GET
        }
    }
}

extension Endpoint {
    
    var url: URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = path
        
        return urlComponents.url
    }
}
