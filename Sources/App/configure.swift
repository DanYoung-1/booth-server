
import S3
import Vapor
import FluentSQLite
import SendGrid
import Leaf

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    
    
    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    

    let directoryConfig = DirectoryConfig.detect()
    services.register(directoryConfig)
    
    
    try services.register(FluentSQLiteProvider())
    // Configure our database
    var databaseConfig = DatabasesConfig()
    let db = try SQLiteDatabase(storage: .file(path: "\(directoryConfig.workDir)auth.db"))
    databaseConfig.add(database: db, as: .sqlite)
    services.register(databaseConfig)
    
    
    // Configure our model migrations
    var migrationConfig = MigrationConfig()
    migrationConfig.add(model: User.self, database: .sqlite)
    migrationConfig.add(model: PhotoStack.self, database: .sqlite)
    migrationConfig.add(model: Video.self, database: .sqlite)
    services.register(migrationConfig)
    
    
    let leafProvider = LeafProvider()
    try services.register(leafProvider)
    config.prefer(LeafRenderer.self, for: ViewRenderer.self)
    
    // Register SendGrid Service
    let sendgridConfig = SendGridConfig(apiKey: "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")
    services.register(sendgridConfig)
    try services.register(SendGridProvider())
    let app = try Application(services: services)
}
