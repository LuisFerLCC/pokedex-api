//
//  PokemonDTO.swift
//  PokedexApi
//
//  Created by Luis Fernando Maldonado Ramírez on 07/06/2025.
//

import Fluent
import Vapor

/// Un Data Transfer Object (DTO) que almacena los datos de un Pokémon.
///
/// La aplicación trabaja con los datos de los Pokémon mediante un modelo de
/// Object-relational Mapping (ORM) llamado ``Pokemon``. No obstante, al enviar
/// los datos al usuario o recibir los datos del usuario por medio de la API, es
/// necesario convertir el modelo a un formato codificable a JSON. Este objetivo
/// se logra por medio de este DTO.
struct PokemonDTO: Content {
    /// El ID del Pokémon en la base de datos.
    var id: Int?
    /// El nombre del Pokémon.
    var nombre: String?
    /// El tipo del Pokémon.
    var tipo: String?
    /// Una breve descripción del Pokémon.
    var descripcion: String?
    /// La URL de la imagen del Pokémon.
    var imagen: String?

    /// Convertir el DTO a un modelo de ORM.
    ///
    /// Una vez recibido el DTO de un Pokémon del usuario, es necesario
    /// convertirlo a un modelo ``Pokemon`` para manipularlo y guardarlo en la
    /// base de datos:
    ///
    ///     let model = dto.toModel()
    ///     try await model.save(on: req.db)
    ///
    func toModel() -> Pokemon {
        let model = Pokemon()

        model.id = self.id
        if let nombre = self.nombre {
            model.nombre = nombre
        }
        if let tipo = self.tipo {
            model.tipo = tipo
        }
        if let descripcion = self.descripcion {
            model.descripcion = descripcion
        }
        if let imagen = self.imagen {
            model.imagen = imagen
        }

        return model
    }
}
