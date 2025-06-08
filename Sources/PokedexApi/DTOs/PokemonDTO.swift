//
//  PokemonDTO.swift
//  PokedexApi
//
//  Created by Luis Fernando Maldonado Ramírez on 07/06/2025.
//

import Fluent
import Vapor

struct PokemonDTO: Content {
    var id: Int?
    var nombre: String?
    var tipo: String?
    var descripcion: String?
    var imagen: String?
    
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
