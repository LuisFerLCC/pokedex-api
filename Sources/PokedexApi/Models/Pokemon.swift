//
//  Pokemon.swift
//  PokedexApi
//
//  Created by Luis Fernando Maldonado Ramírez on 07/06/2025.
//

import Fluent
import Foundation

/// Un modelo de Object-relational Mapping (ORM) que representa a un Pokémon en
/// la base de datos.
///
/// La base de datos almacena la información de varios Pokémon distintos. Este
/// modelo de ORM permite interactuar con los Pokémon almacenados en la base de
/// datos, e incluso permite crear Pokémon nuevos y guardarlos.
///
/// Ejemplo con Chikorita:
///
///     let pokemon = Pokemon(
///         nombre: "Chikorita",
///         tipo: "Planta",
///         descripcion:
///             "Le encanta tomar el sol. Usa la hoja que tiene en la cabeza "
///             + "para localizar sitios cálidos.",
///         imagen:
///             "https://images.wikidexcdn.net/mwuploads/wikidex/4/4e/latest"
///             + "/20230523204350/Chikorita.png",
///     )
///
///     try await pokemon.save(on: req.db)
///
/// Este modelo sólo está pensado para interactuar con los Pokémon _dentro_ de
/// la API. Para enviar los datos de un Pokémon al usuario o recibirlos, es
/// necesario utilizar a un Data Transfer Object (DTO) llamado ``PokemonDTO``.
/// Esto se logra por medio de los métodos ``toDTO()`` y
/// ``PokemonDTO/toModel()``.
final class Pokemon: Model, @unchecked Sendable {
    /// El nombre de la tabla a la que corresponde este modelo en la base de
    /// datos.
    static let schema = "Pokemon"

    /// El ID del Pokémon en la base de datos.
    ///
    /// El ID es un número entero generado automáticamente por la base de datos
    /// de manera incremental; es decir, el primer Pokémon añadido tiene el ID
    /// `1`, el siguiente el ID `2`, y así sucesivamente. Por esta razón, no es
    /// necesario que el usuario asigne un ID manualmente.
    @ID(custom: "id", generatedBy: .database)
    var id: Int?

    /// El nombre del Pokémon.
    ///
    /// Ejemplo con Chikorita:
    ///
    ///     print(pokemon.nombre) // Chikorita
    @Field(key: "nombre")
    var nombre: String

    /// El tipo del Pokémon.
    ///
    /// Ejemplo con Chikorita:
    ///
    ///     print(pokemon.tipo) // Planta
    ///
    /// Cada Pokémon puede tener hasta dos de los tipos siguientes:
    /// - Bicho
    /// - Dragón
    /// - Hada
    /// - Fuego
    /// - Fantasma
    /// - Tierra
    /// - Normal
    /// - Psíqico
    /// - Acero
    /// - Siniestro
    /// - Eléctrico
    /// - Lucha
    /// - Volador
    /// - Planta
    /// - Hielo
    /// - Veneno
    /// - Roca
    /// - Agua
    ///
    /// Para especificar dos tipos, se separan con una diagonal (/). Por
    /// ejemplo, para especificar Planta y Veneno se escribe lo siguiente:
    ///
    ///     pokemon.tipo = "Planta/Veneno"
    @Field(key: "tipo")
    var tipo: String

    /// Una breve descripción del Pokémon.
    ///
    /// Ejemplo con Chikorita:
    ///
    ///     print(pokemon.descripcion)
    ///     // Le encanta tomar el sol. Usa la hoja que tiene en la cabeza para
    ///     // localizar sitios cálidos.
    @Field(key: "descripcion")
    var descripcion: String

    /// La URL de la imagen del Pokémon.
    ///
    /// Ejemplo con Chikorita:
    ///
    ///     print(pokemon.imagen)
    ///     // https://images.wikidexcdn.net/mwuploads/wikidex/4/4e/latest/...
    ///     // 20230523204350/Chikorita.png
    @Field(key: "imagen")
    var imagen: String

    /// Crear un modelo vacío de un Pokémon.
    init() {}

    /// Crear un modelo de un Pokémon con los datos dados.
    ///
    /// - parameters:
    ///     - id: El ID del Pokémon. Definido por defecto por la base de datos.
    ///     - nombre: El nombre del Pokémon.
    ///     - tipo: El tipo del Pokémon.
    ///     - descripcion: Una breve descripción del Pokémon.
    ///     - imagen: La URL de la imagen del Pokémon.
    ///
    /// Ejemplo con Chikorita:
    ///
    ///     let pokemon = Pokemon(
    ///         nombre: "Chikorita",
    ///         tipo: "Planta",
    ///         descripcion:
    ///             "Le encanta tomar el sol. Usa la hoja que tiene en la "
    ///             + "cabeza para localizar sitios cálidos.",
    ///         imagen:
    ///             "https://images.wikidexcdn.net/mwuploads/wikidex/4/4e"
    ///             + "/latest/20230523204350/Chikorita.png",
    ///     )
    ///
    ///     try await pokemon.save(on: req.db)
    ///
    init(id: Int? = nil, nombre: String, tipo: String, descripcion: String, imagen: String) {
        self.id = id
        self.nombre = nombre
        self.tipo = tipo
        self.descripcion = descripcion
        self.imagen = imagen
    }

    /// Convertir el modelo a un DTO.
    ///
    /// Antes de enviar los datos del Pokémon al usuario, es necesario
    /// convertirlos a un DTO llamado ``PokemonDTO`` para traducirlo a JSON:
    ///
    ///     let dto = model.toDTO()
    ///     return dto
    ///
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
