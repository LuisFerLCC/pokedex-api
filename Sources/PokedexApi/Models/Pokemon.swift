//
//  Pokemon.swift
//  PokedexApi
//
//  Created by Luis Fernando Maldonado Ramírez on 07/06/2025.
//

import Fluent
import Foundation

final class Pokemon: Model, @unchecked Sendable {
    static let schema = "Pokemon"

    @ID(custom: "id", generatedBy: .database)
    var id: Int?

    @Field(key: "nombre")
    var nombre: String

    @Field(key: "tipo")
    var tipo: String

    @Field(key: "descripcion")
    var descripcion: String

    @Field(key: "imagen")
    var imagen: String

    init() {}

    init(id: Int? = nil, nombre: String, tipo: String, descripcion: String, imagen: String) {
        self.id = id
        self.nombre = nombre
        self.tipo = tipo
        self.descripcion = descripcion
        self.imagen = imagen
    }
    
    func toDTO() -> PokemonDTO {
        .init(
            id: self.id,
            nombre: self.$nombre.value,
            tipo: self.$tipo.value,
            descripcion: self.$descripcion.value,
            imagen: self.$imagen.value,
        )
    }
}
