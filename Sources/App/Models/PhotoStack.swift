import Vapor
import FluentSQLite

/// A single entry of a PhotoStack.
final class PhotoStack: SQLiteModel {
    var id: Int?
    var urls: [String]
    var userID: User.ID
    
    init(id: Int? = nil, urls: [String] = [], userID: Int) {
        self.id = id
        self.urls = urls
        self.userID = userID
    }
}

enum UrlState: String {
    case uninitialized
    case initialized
    case active
    case publicEnded
}

/// Allows `PhotoStack` to be used as a dynamic migration.
extension PhotoStack: Migration {
    static func revert(on connection: SQLiteConnection) -> Future<Void> {
        return SQLiteDatabase.delete(PhotoStack.self, on: connection)
    }
}
/// Allows `PhotoStack` to be encoded to and decoded from HTTP messages.
extension PhotoStack: Content { }
/// Allows `PhotoStack` to be used as a dynamic parameter in route definitions.
extension PhotoStack: Parameter { }

// foreign key
extension PhotoStack {
    var user: Parent<PhotoStack, User> {
        return parent(\.userID)
    }
}
