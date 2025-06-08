// configures your application

import Fluent

import FluentMySQLDriver

import NIOSSL

import Vapor

public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    var tlsConfiguration = TLSConfiguration.makeClientConfiguration()
    tlsConfiguration.certificateVerification = .none

    app.databases.use(
        DatabaseConfigurationFactory.mysql(
            hostname: Environment.get("DATABASE_HOST") ?? "localhost",
            port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? 3307,
            username: Environment.get("DATABASE_USERNAME") ?? "pokedex_db_user",
            password: Environment.get("DATABASE_PASSWORD") ?? "Pokedex",
            database: Environment.get("DATABASE_NAME") ?? "pokedex_db",
            tlsConfiguration: tlsConfiguration
        ), as: .mysql)

    app.migrations.add(CreatePokemon())

    // register routes
    try routes(app)
}
