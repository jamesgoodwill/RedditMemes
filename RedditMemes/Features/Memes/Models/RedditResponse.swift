import Foundation

struct RedditResponse: Codable {
    let kind: String
    let data: RedditResponseData
}

struct RedditResponseData: Codable {
    let children: [Child]
}

struct Child: Codable {
    let kind: String
    let data: ChildData
}

struct ChildData: Codable {
    let id: String
    let author: String?
    let title: String?
    let body: String?
    let ups: Int?
    let numComments: Int?
    let url: String?
    let permalink: String?

    enum CodingKeys: String, CodingKey {
        case id
        case author
        case title
        case body
        case ups
        case numComments = "num_comments"
        case url
        case permalink
    }
}
