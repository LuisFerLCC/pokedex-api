//
//  PokemonController.swift
//  PokedexApi
//
//  Created by Luis Fernando Maldonado Ramírez on 07/06/2025.
//

import Fluent
import Vapor

/// Define los endpoints de la API para interactuar con los datos de los
/// Pokémon.
///
/// Este controlador define una subruta en la aplicación llamada `pokemon`, la
/// cual contiene todos los endpoints para realizar las operaciones CRUD sobre
/// los Pokémon registrados.
///
/// Para añadir este controlador a la aplicación, añadimos lo siguiente dentro
/// de nuestra función ``routes(_:)`` en nuestro archivo _routes.swift_:
///
///     try app.register(collection: PokemonController())
///
struct PokemonController: RouteCollection {
    /// Registra los endpoints del controlador. No es necesario llamar a esta
    /// función manualmente.
    ///
    /// - parameters:
    ///     - routes: El `RoutesBuilder` utilizado para registrar los endpoints.
    func boot(routes: any RoutesBuilder) throws {
        let pokemon = routes.grouped("pokemon")

        pokemon.get(use: self.index)
        pokemon.post(use: self.create)

        pokemon.group(":id") { pokemon in
            pokemon.get(use: self.getByID)
            pokemon.put(use: self.replace)
            pokemon.patch(use: self.update)
            pokemon.delete(use: self.delete)
        }
    }

    /// Endpoint `GET /pokemon`: Obtener una lista de los Pokémon, la cual
    /// podemos filtrar por nombre y/o por tipo.
    ///
    /// Este endpoint se encuentra en `/pokemon` con el método `GET`. Retorna
    /// una lista de los Pokémon registrados en la base de datos.
    ///
    /// ### Parámetros de consulta
    /// - `nombre`: Filtrar por nombre.
    /// - `tipo`: Filtrar por tipo.
    @Sendable
    func index(req: Request) async throws -> [PokemonDTO] {
        var query: QueryBuilder<Pokemon> = Pokemon.query(on: req.db)

        if let nameFilter = try? req.query.get(String.self, at: "nombre") {
            query = query.filter(\Pokemon.$nombre == nameFilter)
        }
        if let typeFilter = try? req.query.get(String.self, at: "tipo") {
            query = query.filter(\Pokemon.$tipo == typeFilter)
        }

        return try await query.all().map { model in
            model.toDTO()
        }
    }

    /// Endpoint `GET /pokemon/:id`: Obtener un Pokémon a partir de su ID.
    ///
    /// Este endpoint se encuentra en `/pokemon/:id` con el método `GET`.
    /// Retorna los datos del Pokémon con el ID proporcionado.
    ///
    /// ### Parámetros de ruta
    /// - `id`: El ID del Pokémon.
    ///
    /// ### Errores
    /// - `Not Found`: No existe un Pokémon con el ID proporcionado.
    @Sendable
    func getByID(req: Request) async throws -> PokemonDTO {
        let id = req.parameters.get("id") ?? ""
        guard let model = try await Pokemon.find(Int(id), on: req.db) else {
            throw Abort(.notFound)
        }

        return model.toDTO()
    }

    /// Endpoint `POST /pokemon`: Crear un nuevo Pokémon.
    ///
    /// Este endpoint se encuentra en `/pokemon` con el método `POST`. Permite
    /// registrar un nuevo Pokémon en la base de datos.
    ///
    /// ### Cuerpo de la solicitud
    /// Debe enviarse un objeto JSON con la siguiente estructura:
    /// ```json
    /// {
    ///   "nombre": "string",
    ///   "tipo": "string",
    ///   "descripcion": "string",
    ///   "imagen": "string"
    /// }
    /// ```
    ///
    /// - `nombre`: El nombre del Pokémon (obligatorio).
    /// - `tipo`: El tipo del Pokémon (obligatorio).
    /// - `descripcion`: Una descripción del Pokémon (obligatorio).
    /// - `imagen`: La URL de la imagen del Pokémon (obligatorio).
    ///
    /// ### Respuesta
    /// Retorna un objeto JSON con los datos del Pokémon creado.
    ///
    /// ### Errores
    /// - `Bad Request`: El cuerpo de la solicitud no es válido o faltan campos
    ///                  obligatorios.
    @Sendable
    func create(req: Request) async throws -> PokemonDTO {
        let model = try req.content.decode(PokemonDTO.self).toModel()

        try await model.save(on: req.db)
        return model.toDTO()
    }

    /// Endpoint `PUT /pokemon/:id`: Reemplazar un Pokémon existente.
    ///
    /// Este endpoint se encuentra en `/pokemon/:id` con el método `PUT`.
    /// Permite reemplazar completamente los datos de un Pokémon existente
    /// con los datos proporcionados en el cuerpo de la solicitud.
    ///
    /// ### Parámetros de ruta
    /// - `id`: El ID del Pokémon que se desea reemplazar.
    ///
    /// ### Cuerpo de la solicitud
    /// Debe enviarse un objeto JSON con la siguiente estructura:
    /// ```json
    /// {
    ///   "nombre": "string",
    ///   "tipo": "string",
    ///   "descripcion": "string",
    ///   "imagen": "string"
    /// }
    /// ```
    ///
    /// - `nombre`: El nombre del Pokémon (obligatorio).
    /// - `tipo`: El tipo del Pokémon (obligatorio).
    /// - `descripcion`: Una descripción del Pokémon (obligatorio).
    /// - `imagen`: La URL de la imagen del Pokémon (obligatorio).
    ///
    /// ### Respuesta
    /// Retorna un objeto JSON con los datos del Pokémon actualizado.
    ///
    /// ### Errores
    /// - `Not Found`: No existe un Pokémon con el ID proporcionado.
    /// - `Bad Request`: El cuerpo de la solicitud no es válido o faltan campos
    ///                  obligatorios.
    @Sendable
    func replace(req: Request) async throws -> PokemonDTO {
        let id = req.parameters.get("id") ?? ""
        guard let model = try await Pokemon.find(Int(id), on: req.db) else {
            throw Abort(.notFound)
        }

        let newDTO = try req.content.decode(PokemonDTO.self)
        guard let nombre = newDTO.nombre else { throw Abort(.badRequest) }
        guard let tipo = newDTO.tipo else { throw Abort(.badRequest) }
        guard let descripcion = newDTO.descripcion else {
            throw Abort(.badRequest)
        }
        guard let imagen = newDTO.imagen else { throw Abort(.badRequest) }

        model.nombre = nombre
        model.tipo = tipo
        model.descripcion = descripcion
        model.imagen = imagen

        try await model.save(on: req.db)
        return model.toDTO()
    }

    /// Endpoint `PATCH /pokemon/:id`: Actualizar parcialmente un Pokémon
    /// existente.
    ///
    /// Este endpoint se encuentra en `/pokemon/:id` con el método `PATCH`.
    /// Permite actualizar parcialmente los datos de un Pokémon existente
    /// con los datos proporcionados en el cuerpo de la solicitud.
    ///
    /// ### Parámetros de ruta
    /// - `id`: El ID del Pokémon que se desea actualizar.
    ///
    /// ### Cuerpo de la solicitud
    /// Debe enviarse un objeto JSON con la siguiente estructura:
    /// ```json
    /// {
    ///   "nombre": "string",
    ///   "tipo": "string",
    ///   "descripcion": "string",
    ///   "imagen": "string"
    /// }
    /// ```
    ///
    /// - `nombre`: El nuevo nombre del Pokémon (opcional).
    /// - `tipo`: El nuevo tipo del Pokémon (opcional).
    /// - `descripcion`: La nueva descripción del Pokémon (opcional).
    /// - `imagen`: La nueva URL de la imagen del Pokémon (opcional).
    ///
    /// ### Respuesta
    /// Retorna un objeto JSON con los datos del Pokémon actualizado.
    ///
    /// ### Errores
    /// - `Not Found`: No existe un Pokémon con el ID proporcionado.
    /// - `Bad Request`: El cuerpo de la solicitud no es válido.
    @Sendable
    func update(req: Request) async throws -> PokemonDTO {
        let id = req.parameters.get("id") ?? ""
        guard let model = try await Pokemon.find(Int(id), on: req.db) else {
            throw Abort(.notFound)
        }

        let changes = try req.content.decode(PokemonDTO.self)
        if let nombre = changes.nombre {
            model.nombre = nombre
        }
        if let tipo = changes.tipo {
            model.tipo = tipo
        }
        if let descripcion = changes.descripcion {
            model.descripcion = descripcion
        }
        if let imagen = changes.imagen {
            model.imagen = imagen
        }

        try await model.save(on: req.db)
        return model.toDTO()
    }

    /// Endpoint `DELETE /pokemon/:id`: Eliminar un Pokémon existente.
    ///
    /// Este endpoint se encuentra en `/pokemon/:id` con el método `DELETE`.
    /// Permite eliminar un Pokémon existente de la base de datos.
    ///
    /// ### Parámetros de ruta
    /// - `id`: El ID del Pokémon que se desea eliminar.
    ///
    /// ### Respuesta
    /// Retorna un estado HTTP `204 No Content` si la operación es exitosa.
    ///
    /// ### Errores
    /// - `Not Found`: No existe un Pokémon con el ID proporcionado.
    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        let id = req.parameters.get("id") ?? ""
        guard let model = try await Pokemon.find(Int(id), on: req.db) else {
            throw Abort(.notFound)
        }

        try await model.delete(on: req.db)
        return .noContent
    }
}
