# Integrantes del equipo

- Víctor Alejandro Márquez Mares
- Luis Fernando Maldonado Ramírez
- Carlos Joel Martínez López
- Jesús Emiliano Rodríguez Muñoz

# Pokédex API

Una API RESTful con el set completo de operaciones CRUD para interactuar con una base de datos de Pokémon basada en MySQL Community Server.

Consta de una sola entidad (los Pokémon), la cual contiene los siguientes datos de cada Pokémon:
- El nombre
- El tipo (o los tipos, si tiene dos)
- Una breve descripción
- La URL de su imagen

## Endpoints

### `GET /`

Si la API está funcionando correctamente, muestra el siguiente mensaje:

```
It works!
```

### `GET /pokemon`

Retorna una lista de los Pokémon registrados en la base de datos.

#### Parámetros de consulta
- `nombre`: Filtrar por nombre.
- `tipo`: Filtrar por tipo.

#### Ejemplo
```
GET /pokemon?nombre=Pikachu ... 200 OK
```
```json
[
    {
        "nombre": "Pikachu",
        "descripcion": "Almacena electricidad en sus mejillas. La libera cuando se enoja o se defiende.",
        "id": 25,
        "tipo": "Eléctrico",
        "imagen": "https://images.wikidexcdn.net/mwuploads/wikidex/9/9f/latest/20221107215512/Pikachu.png"
    }
]
```

### `GET /pokemon/:id`

Retorna los datos del Pokémon con el ID proporcionado.

#### Parámetros de ruta
- `id`: El ID del Pokémon.

#### Errores
- `Not Found`: No existe un Pokémon con el ID proporcionado.

#### Ejemplo
```
GET /pokemon/133 ... 200 OK
```
```json
{
    "tipo": "Normal",
    "imagen": "https://images.wikidexcdn.net/mwuploads/wikidex/0/01/latest/20221107215511/Eevee.png",
    "id": 133,
    "descripcion": "Con múltiples posibles evoluciones, es muy adaptable.",
    "nombre": "Eevee"
}
```

#### Ejemplo (no encontrado)
```
GET /pokemon/155 ... 404 Not Found
```
```json
{
    "error": true,
	"reason": "Not Found"
}
```

### `POST /pokemon`

Permite registrar un nuevo Pokémon en la base de datos.

#### Cuerpo de la solicitud
Debe enviarse un objeto JSON con la siguiente estructura:
```json
{
	"nombre": "string",
	"tipo": "string",
	"descripcion": "string",
	"imagen": "string"
}
```

- `nombre`: El nombre del Pokémon (obligatorio).
- `tipo`: El tipo del Pokémon (obligatorio).
- `descripcion`: Una descripción del Pokémon (obligatorio).
- `imagen`: La URL de la imagen del Pokémon (obligatorio).

#### Respuesta
Retorna un objeto JSON con los datos del Pokémon creado.

#### Errores
- `Bad Request`: El cuerpo de la solicitud no es válido o faltan campos obligatorios.

#### Ejemplo
```
POST /pokemon
```
```json
{
    "nombre": "Chikorita",
    "tipo": "Planta",
    "descripcion": "Le encanta tomar el sol. Usa la hoja que tiene en la cabeza para localizar sitios cálidos.",
    "imagen": "https://images.wikidexcdn.net/mwuploads/wikidex/4/4e/latest/20230523204350/Chikorita.png"
}
```
```
200 OK
```
```json
{
    "imagen": "https://images.wikidexcdn.net/mwuploads/wikidex/4/4e/latest/20230523204350/Chikorita.png",
    "descripcion": "Le encanta tomar el sol. Usa la hoja que tiene en la cabeza para localizar sitios cálidos.",
    "nombre": "Chikorita",
    "tipo": "Planta",
    "id": 152
}
```

### `PUT /pokemon/:id`

Permite reemplazar completamente los datos de un Pokémon existente con los datos proporcionados en el cuerpo de la solicitud.

#### Parámetros de ruta
- `id`: El ID del Pokémon que se desea reemplazar.

#### Cuerpo de la solicitud
Debe enviarse un objeto JSON con la siguiente estructura:
```json
{
	"nombre": "string",
	"tipo": "string",
	"descripcion": "string",
	"imagen": "string"
}
```

- `nombre`: El nombre del Pokémon (obligatorio).
- `tipo`: El tipo del Pokémon (obligatorio).
- `descripcion`: Una descripción del Pokémon (obligatorio).
- `imagen`: La URL de la imagen del Pokémon (obligatorio).

#### Respuesta
Retorna un objeto JSON con los datos del Pokémon actualizado.

#### Errores
- `Not Found`: No existe un Pokémon con el ID proporcionado.
- `Bad Request`: El cuerpo de la solicitud no es válido o faltan campos obligatorios.

#### Ejemplo
```
PUT /pokemon/152
```
```json
{
    "nombre": "Chespin",
    "tipo": "Planta",
    "descripcion": "Cuando acumula energía antes de propinar un cabezazo, las púas de su cabeza se vuelven tan afiladas que atraviesan el cuerpo del enemigo.",
    "imagen": "https://images.wikidexcdn.net/mwuploads/wikidex/4/46/latest/20190430155233/Chespin.png"
}
```
```
200 OK
```
```json
{
    "id": 152,
    "nombre": "Chespin",
    "descripcion": "Cuando acumula energía antes de propinar un cabezazo, las púas de su cabeza se vuelven tan afiladas que atraviesan el cuerpo del enemigo.",
    "imagen": "https://images.wikidexcdn.net/mwuploads/wikidex/4/46/latest/20190430155233/Chespin.png",
    "tipo": "Planta"
}
```

### `PATCH /pokemon/:id`

Permite actualizar parcialmente los datos de un Pokémon existente con los datos proporcionados en el cuerpo de la solicitud.

#### Parámetros de ruta
- `id`: El ID del Pokémon que se desea actualizar.

#### Cuerpo de la solicitud
Debe enviarse un objeto JSON con la siguiente estructura:
```json
{
	"nombre": "string",
	"tipo": "string",
	"descripcion": "string",
	"imagen": "string"
}
```

- `nombre`: El nombre del Pokémon (opcional).
- `tipo`: El tipo del Pokémon (opcional).
- `descripcion`: Una descripción del Pokémon (opcional).
- `imagen`: La URL de la imagen del Pokémon (opcional).

#### Respuesta
Retorna un objeto JSON con los datos del Pokémon actualizado.

#### Errores
- `Not Found`: No existe un Pokémon con el ID proporcionado.
- `Bad Request`: El cuerpo de la solicitud no es válido.

#### Ejemplo
```
PATCH /pokemon/124
```
```json
{
    "descripcion": "En cierta parte de Galar se conocía a Jynx como la Reina del Hielo y se reverenciaba con cierto temor."
}
```
```
200 OK
```
```json
{
    "tipo": "Hielo/Psíquico",
    "descripcion": "En cierta parte de Galar se conocía a Jynx como la Reina del Hielo y se reverenciaba con cierto temor.",
    "nombre": "Jynx",
    "imagen": "https://images.wikidexcdn.net/mwuploads/wikidex/f/f1/latest/20221107215511/Jynx.png",
    "id": 124
}
```

### `DELETE /pokemon/:id`

Permite eliminar un Pokémon existente de la base de datos.

#### Parámetros de ruta
- `id`: El ID del Pokémon que se desea eliminar.

#### Respuesta
Retorna un estado HTTP `204 No Content` si la operación es exitosa.

#### Errores
- `Not Found`: No existe un Pokémon con el ID proporcionado.

#### Ejemplo
```
DELETE /pokemon/124 ... 204 No Content
```
