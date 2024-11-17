import Foundation

struct Book: Hashable, Codable {
    let id: Int
    let title: String
    let author: String
    let isbn: String
    let publishedYear: Int
    let noOfAvailableCopies: Int
}

struct CreateBookRequest: Codable {
    let title: String
    let author: String
    let isbn: String
    let publishedYear: Int
    let noOfAvailableCopies: Int
} 