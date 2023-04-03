import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    
    let databaseName: String
    let databasePort: Int
    
    if (app.environment == .testing) {
        databaseName = "vapor-test"
        databasePort = 5433
    } else {
        databaseName = "VaporTrailblazer"
        databasePort = 5432
    }
    //vapor-trailblazer.ctyve6nsk49p.us-east-1.rds.amazonaws.com
    app.databases.use(.postgres(
        hostname: Environment.get("DATABASE_HOST")
        ?? "vapor-trailblazer.ctyve6nsk49p.us-east-1.rds.amazonaws.com",
        port: databasePort,
        username: Environment.get("DATABASE_USERNAME")
        ?? "mckee_p",
        password: Environment.get("DATABASE_PASSWORD")
        ?? "trailblazer",
        database: Environment.get("DATABASE_NAME")
        ?? databaseName
    ), as: .psql)
    
    app.passwords.use(.bcrypt)
    app.migrations.add(CreateUser())
    app.migrations.add(CreateTrailReports())
    app.migrations.add(CreateUserLocations())
    app.migrations.add(CreateUserRoutes())
    app.migrations.add(CreateMaps())
    app.migrations.add(CreateMapTrails())
    app.migrations.add(CreateMapConnectors())
    app.migrations.add(CreatePoints())
    app.migrations.add(CreateMapFiles())
    
    app.logger.logLevel = .debug

    try app.autoMigrate().wait()
    
    try routes(app)
}
