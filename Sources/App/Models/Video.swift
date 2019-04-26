import Vapor
import FluentSQLite

/// A single entry of a PhotoStack.
final class Video: SQLiteModel {
    var id: Int?
    var url: String
    var userID: User.ID
    
    init(id: Int? = nil, url: String, userID: Int) {
        self.id = id
        self.url = url
        self.userID = userID
    }
}

/// Allows `PhotoStack` to be used as a dynamic migration.
extension Video: Migration {
    static func revert(on connection: SQLiteConnection) -> Future<Void> {
        return SQLiteDatabase.delete(PhotoStack.self, on: connection)
    }
}
/// Allows `PhotoStack` to be encoded to and decoded from HTTP messages.
extension Video: Content { }
/// Allows `PhotoStack` to be used as a dynamic parameter in route definitions.
extension Video: Parameter { }

// foreign key
extension Video {
    var user: Parent<Video, User> {
        return parent(\.userID)
    }
}
