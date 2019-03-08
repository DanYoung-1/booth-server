import Vapor
import FluentSQLite

/// A single entry of a PhotoStack.
final class PhotoStack: SQLiteModel {
    var id: Int?
    var date: Date
    var urls: [URL]
    var userID: User.ID
    init(id: Int? = nil, date: Date, urls: [URL], userID: Int) {
        self.id = id
        self.date = date
        self.urls = urls
        self.userID = userID
    }
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
