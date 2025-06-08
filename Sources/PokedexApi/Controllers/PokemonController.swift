//
//  PokemonController.swift
//  PokedexApi
//
//  Created by Luis Fernando Maldonado Ramírez on 07/06/2025.
//

import Fluent
import Vapor

struct PokemonController: RouteCollection {
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
    
    @Sendable
    func getByID(req: Request) async throws -> PokemonDTO {
        let id = req.parameters.get("id") ?? ""
        guard let model = try await Pokemon.find(Int(id), on: req.db) else {
            throw Abort(.notFound)
        }
        
        return model.toDTO()
    }
    
    @Sendable
    func create(req: Request) async throws -> PokemonDTO {
        let model = try req.content.decode(PokemonDTO.self).toModel()
        
        try await model.save(on: req.db)
        return model.toDTO()
    }
    
    @Sendable
    func replace(req: Request) async throws -> PokemonDTO {
        let id = req.parameters.get("id") ?? ""
        guard let model = try await Pokemon.find(Int(id), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let newDTO = try req.content.decode(PokemonDTO.self)
        guard let nombre = newDTO.nombre else { throw Abort(.badRequest) }
        guard let tipo = newDTO.tipo else { throw Abort(.badRequest) }
        guard let descripcion = newDTO.descripcion else { throw Abort(.badRequest) }
        guard let imagen = newDTO.imagen else { throw Abort(.badRequest) }
        
        model.nombre = nombre
        model.tipo = tipo
        model.descripcion = descripcion
        model.imagen = imagen
        
        try await model.save(on: req.db)
        return model.toDTO()
    }
    
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
