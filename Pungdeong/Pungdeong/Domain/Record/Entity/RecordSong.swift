import Foundation

/// Keeps the selected song readable even without a new catalog request.
struct RecordSong: Codable, Equatable, Identifiable {
    let id: String
    let title: String
    let artistName: String
    let artworkURL: URL?
    let url: URL?
}
