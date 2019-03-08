import Vapor
import FluentSQLite

/// A single entry of a User.
final class User: SQLiteModel {
    var id: Int?
    var email: String
    init(id: Int? = nil, email: String) {
        self.id = id
        self.email = email
    }
}

/// Allows `User` to be used as a dynamic migration.
extension User: Migration {
    static func revert(on connection: SQLiteConnection) -> Future<Void> {
        return SQLiteDatabase.delete(PhotoStack.self, on: connection)
    }
}
/// Allows `User` to be encoded to and decoded from HTTP messages.
extension User: Content { }
/// Allows `User` to be used as a dynamic parameter in route definitions.
extension User: Parameter { }


extension User {
    var photoStacks: Children<User, PhotoStack> {
        return children(\.userID)
    }
}
