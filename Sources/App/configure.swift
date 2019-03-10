
import S3
import Vapor
import FluentSQLite
import SendGrid

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    
    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    let directoryConfig = DirectoryConfig.detect()
    services.register(directoryConfig)
    
    // Configure our database
    var databaseConfig = DatabasesConfig()
    let db = try SQLiteDatabase(storage: .file(path: "\(directoryConfig.workDir)auth.db"))
    databaseConfig.add(database: db, as: .sqlite)
    services.register(databaseConfig)
    
    // Configure our model migrations
    var migrations = MigrationConfig()
    migrations.add(model: User.self, database: .sqlite)
    migrations.add(model: PhotoStack.self, database: .sqlite)
    services.register(migrations)
    
    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    // middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)
    
    
    // Register S3 service
    let config = S3Signer.Config(
        accessKey: "AKIAJK6D3XPJY3W5RMZA",
        secretKey: "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",
        region: Region(name: Region.RegionName.usWest2,
        hostName: "127.0.0.1:8080", useTLS: false))
    // with default bucket
    try services.register(s3: config, defaultBucket: "my-booth-bucket")
    
    // Register SendGrid Service
    let sendgridConfig = SendGridConfig(apiKey: "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")
    services.register(sendgridConfig)
    try services.register(SendGridProvider())
    let app = try Application(services: services)
    let sendGridClient = try app.make(SendGridClient.self)
}
