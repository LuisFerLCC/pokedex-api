//
//  CreatePokemon.swift
//  PokedexApi
//
//  Created by Luis Fernando Maldonado Ramírez on 07/06/2025.
//

import Fluent

/// Migración de base de datos que añade la tabla de Pokémon y sus tuplas
/// iniciales.
///
/// Esta migración crea la tabla `Pokemon` con sus columnas constituyentes en la
/// base de datos. También añade a los primeros 151 Pokémon de la Pokédex
/// oficial.
///
/// Para añadir esta migración a la aplicación, añadimos lo siguiente dentro de
/// la función ``configure(_:)`` en el archivo _configure.swift_:
///
///     app.migrations.add(CreatePokemon())
///
struct CreatePokemon: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("Pokemon")
            .field("id", .int, .identifier(auto: true))
            .field("nombre", .string, .required)
            .field("tipo", .string, .required)
            .field("descripcion", .string, .required)
            .field("imagen", .string, .required)
            .create()

        let pokemon = _data.map { tuple in
            Pokemon(
                id: nil,
                nombre: tuple.0,
                tipo: tuple.1,
                descripcion: tuple.2,
                imagen: tuple.3
            )
        }

        try await database.transaction { database in
            for p in pokemon {
                try await p.save(on: database)
            }
        }
    }

    func revert(on database: any Database) async throws {
        try await database.schema("Pokemon").delete()
    }
}

private let _data = [
    (
        "Bulbasaur", "Planta/Veneno",
        "Bulbasaur es un Pokémon de tipo Planta y Veneno. Es conocido por tener una planta en su espalda que crece a medida que evoluciona.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/4/43/latest/20190406170624/Bulbasaur.png"
    ),
    (
        "Ivysaur", "Planta/Veneno",
        "Ivysaur es la evolución de Bulbasaur. Su planta ha crecido y ahora tiene una flor en su espalda.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/8/86/latest/20190406151903/Ivysaur.png"
    ),
    (
        "Venusaur", "Planta/Veneno",
        "Venusaur es la forma final de Bulbasaur. Su planta ha florecido completamente y es un Pokémon muy poderoso.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/b/be/latest/20160309230456/Venusaur.png"
    ),
    (
        "Charmander", "Fuego",
        "Charmander es un Pokémon de tipo Fuego. Tiene una llama en la punta de su cola que indica su salud y estado de ánimo.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/5/56/latest/20200307023245/Charmander.png"
    ),
    (
        "Charmeleon", "Fuego",
        "Charmeleon es la evolución de Charmander. Su llama se vuelve más intensa y es más agresivo.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/f/fb/latest/20200411222755/Charmeleon.png"
    ),
    (
        "Charizard", "Fuego/Volador",
        "Charizard es la forma final de Charmander. Es un Pokémon poderoso que puede volar y lanzar fuego.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/9/95/latest/20160817212623/Charizard.png"
    ),
    (
        "Squirtle", "Agua",
        "Rechaza agua por la boca con gran precisión para atacar o defenderse.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/e/e3/latest/20160309230820/Squirtle.png"
    ),
    (
        "Wartortle", "Agua", "Tiene orejas peludas y cola espesa. Vive mucho tiempo.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/d/d7/latest/20200307022248/Wartortle.png"
    ),
    (
        "Blastoise", "Agua",
        "Tiene cañones de agua en su caparazón que disparan a alta presión.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/4/41/latest/20200411222955/Blastoise.png"
    ),
    (
        "Caterpie", "Bicho",
        "Sus patas le ayudan a escalar muros y árboles. Libera un hedor por sus antenas para repeler enemigos.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/0/05/latest/20230716211653/Caterpie.png"
    ),
    (
        "Metapod", "Bicho",
        "Aunque está casi inmóvil, dentro de su caparazón está evolucionando.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/6/6b/latest/20200307022334/Metapod.png"
    ),
    (
        "Butterfree", "Bicho/Volador",
        "Sus alas están cubiertas de polvos tóxicos que paralizan a los enemigos.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/9/96/latest/20160703192952/Butterfree.png"
    ),
    (
        "Weedle", "Bicho/Veneno",
        "Tiene un aguijón venenoso en la cabeza. Es común en los bosques.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/d/d6/latest/20200307022415/Weedle.png"
    ),
    (
        "Kakuna", "Bicho/Veneno",
        "Permanece inmóvil mientras evoluciona. Su cuerpo es duro como el acero.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/6/63/latest/20200307022526/Kakuna.png"
    ),
    (
        "Beedrill", "Bicho/Veneno", "Ataca en grupo con los aguijones de sus patas delanteras.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/0/0d/latest/20200307022638/Beedrill.png"
    ),
    (
        "Pidgey", "Normal/Volador",
        "Este dócil Pokémon vuela bajo buscando insectos que comer.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/b/b3/latest/20221107215512/Pidgey.png"
    ),
    (
        "Pidgeotto", "Normal/Volador",
        "Patrulla su territorio desde el aire. Tiene muy buena vista.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/6/64/latest/20221107215512/Pidgeotto.png"
    ),
    (
        "Pidgeot", "Normal/Volador",
        "Sus alas le permiten volar a una velocidad cercana a la del sonido.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/2/25/latest/20221107215511/Pidgeot.png"
    ),
    (
        "Rattata", "Normal",
        "Sus dientes crecen constantemente, por lo que roe cualquier cosa.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/b/b2/latest/20221107215513/Rattata.png"
    ),
    (
        "Raticate", "Normal",
        "Usa sus enormes colmillos para cortar cosas gruesas como troncos.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/c/ce/latest/20221107215514/Raticate.png"
    ),
    (
        "Spearow", "Normal/Volador",
        "Agresivo por naturaleza. Ataca a cualquier cosa que invada su territorio.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/2/2c/latest/20221107215514/Spearow.png"
    ),
    (
        "Fearow", "Normal/Volador",
        "Tiene un pico largo y delgado. Es capaz de volar durante horas sin descansar.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/0/0a/latest/20221107215510/Fearow.png"
    ),
    (
        "Ekans", "Veneno",
        "Se enrolla para descansar o atacar. Puede moverse sigilosamente por el pasto.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/3/35/latest/20221107215509/Ekans.png"
    ),
    (
        "Arbok", "Veneno",
        "El dibujo de su panza intimida a sus enemigos. Cada ejemplar tiene un patrón único.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/2/2d/latest/20221107215507/Arbok.png"
    ),
    (
        "Pikachu", "Eléctrico",
        "Almacena electricidad en sus mejillas. La libera cuando se enoja o se defiende.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/9/9f/latest/20221107215512/Pikachu.png"
    ),
    (
        "Raichu", "Eléctrico",
        "Su cola actúa como pararrayos. Puede liberar descargas de hasta 100,000 voltios.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/7/71/latest/20221107215513/Raichu.png"
    ),
    (
        "Sandshrew", "Tierra",
        "Su piel dura y seca lo protege del calor. Se enrosca para defenderse.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/0/0d/latest/20221107215514/Sandshrew.png"
    ),
    (
        "Sandslash", "Tierra", "Cuando se enrolla, sus púas se levantan para protegerlo.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/d/d3/latest/20221107215514/Sandslash.png"
    ),
    (
        "Nidoran♀", "Veneno",
        "Sus orejas están afinadas para detectar peligros. Ataca con su cuerno tóxico.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/6/64/latest/20221107215511/Nidoran_hembra.png"
    ),
    (
        "Nidorina", "Veneno",
        "Se vuelve más tranquila al evolucionar. Protege a sus crías con ferocidad.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/1/11/latest/20221107215510/Nidorina.png"
    ),
    (
        "Nidoqueen", "Veneno/Tierra",
        "Tiene un cuerpo robusto y musculoso. Protege con fiereza a sus crías.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/b/bc/latest/20221107215510/Nidoqueen.png"
    ),
    (
        "Nidoran♂", "Veneno",
        "Sus orejas detectan sonidos lejanos. Tiene un cuerno más grande que la hembra.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/2/2b/latest/20221107215511/Nidoran_macho.png"
    ),
    (
        "Nidorino", "Veneno", "Extremadamente agresivo. Su cuerno se endurece y es venenoso.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/7/78/latest/20221107215511/Nidorino.png"
    ),
    (
        "Nidoking", "Veneno/Tierra",
        "Su cola es poderosa. Puede derribar una casa con un solo golpe.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/a/a6/latest/20221107215510/Nidoking.png"
    ),
    (
        "Clefairy", "Hada",
        "Se dice que trae buena suerte. Le gusta bailar bajo la luz de la luna.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/5/59/latest/20221107215508/Clefairy.png"
    ),
    (
        "Clefable", "Hada",
        "Es muy tímido y rara vez se deja ver. Sus pasos son tan ligeros que no hacen ruido.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/e/ea/latest/20221107215508/Clefable.png"
    ),
    (
        "Vulpix", "Fuego", "Tiene seis colas que se separan y se alargan con la edad.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/c/ce/latest/20221107215515/Vulpix.png"
    ),
    (
        "Ninetales", "Fuego",
        "Cada una de sus colas tiene un poder místico. Se dice que vive mil años.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/d/db/latest/20221107215510/Ninetales.png"
    ),
    (
        "Jigglypuff", "Normal/Hada",
        "Canta canciones de cuna con una voz dulce. Su canto adormece al oponente.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/4/41/latest/20221107215509/Jigglypuff.png"
    ),
    (
        "Wigglytuff", "Normal/Hada",
        "Su cuerpo es muy elástico. Se infla como un globo cuando respira profundamente.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/0/00/latest/20221107215515/Wigglytuff.png"
    ),
    (
        "Zubat", "Veneno/Volador", "Vive en cuevas oscuras. Usa ecolocalización para navegar.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/4/44/latest/20221107215509/Zubat.png"
    ),
    (
        "Golbat", "Veneno/Volador",
        "Se alimenta de la sangre de animales y humanos mientras duermen.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/f/f1/latest/20221107215510/Golbat.png"
    ),
    (
        "Oddish", "Planta/Veneno",
        "Durante el día se entierra y por la noche busca luz para absorber.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/d/d0/latest/20221107215514/Oddish.png"
    ),
    (
        "Gloom", "Planta/Veneno", "Emite un olor desagradable para alejar a sus enemigos.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/3/30/latest/20221107215510/Gloom.png"
    ),
    (
        "Vileplume", "Planta/Veneno",
        "Su flor libera un polen tóxico que puede hacer dormir a su presa.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/6/6d/latest/20221107215509/Vileplume.png"
    ),
    (
        "Paras", "Bicho/Planta",
        "Sus hongos crecen sobre su espalda y controlan parcialmente sus acciones.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/0/0f/latest/20221107215512/Paras.png"
    ),
    (
        "Parasect", "Bicho/Planta",
        "El hongo ha tomado control total sobre el cuerpo de Paras.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/d/d4/latest/20221107215511/Parasect.png"
    ),
    (
        "Venonat", "Bicho/Veneno", "Sus grandes ojos le permiten ver en la oscuridad.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/1/13/latest/20221107215509/Venonat.png"
    ),
    (
        "Venomoth", "Bicho/Veneno",
        "Tiene polvos venenosos en sus alas que paralizan a sus enemigos.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/6/63/latest/20221107215513/Venomoth.png"
    ),
    (
        "Diglett", "Tierra",
        "Pasa la mayor parte de su vida bajo tierra. Puede excavar rápido.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/3/31/latest/20221107215511/Diglett.png"
    ),
    (
        "Dugtrio", "Tierra",
        "Tres Digletts que emergen juntos del suelo. Trabajan en equipo para excavar.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/a/a6/latest/20221107215512/Dugtrio.png"
    ),
    (
        "Meowth", "Normal",
        "Le encanta coleccionar objetos brillantes y usarlos como juguetes.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/7/7e/latest/20221107215513/Meowth.png"
    ),
    (
        "Persian", "Normal",
        "Es muy elegante y orgulloso. Usa su velocidad para evitar ataques.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/9/98/latest/20221107215512/Persian.png"
    ),
    (
        "Psyduck", "Agua", "Sufre de constantes dolores de cabeza que liberan poderosas ondas.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/c/c4/latest/20221107215513/Psyduck.png"
    ),
    (
        "Golduck", "Agua",
        "Puede nadar a gran velocidad y usar poderes psíquicos cuando está concentrado.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/7/76/latest/20221107215513/Golduck.png"
    ),
    (
        "Mankey", "Lucha", "Muy agresivo y rápido. Siempre está listo para pelear.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/e/e1/latest/20221107215514/Mankey.png"
    ),
    (
        "Primeape", "Lucha", "Su furia puede hacer que pierda el control y ataque a todo.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/a/a2/latest/20221107215514/Primeape.png"
    ),
    (
        "Growlithe", "Fuego", "Leal y valiente, protege a su entrenador sin dudar.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/4/4d/latest/20221107215513/Growlithe.png"
    ),
    (
        "Arcanine", "Fuego",
        "Corre a velocidades increíbles y puede cubrir grandes distancias.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/5/57/latest/20221107215511/Arcanine.png"
    ),
    (
        "Poliwag", "Agua",
        "Su cuerpo está cubierto por una piel resbaladiza y su espiral en el vientre indica su salud.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/4/42/latest/20221107215510/Poliwag.png"
    ),
    (
        "Poliwhirl", "Agua",
        "Tiene una piel resbaladiza que le permite moverse rápidamente en el agua y en tierra.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/8/87/latest/20221107215510/Poliwhirl.png"
    ),
    (
        "Poliwrath", "Agua/Lucha",
        "Su musculatura es poderosa, capaz de derribar obstáculos con facilidad.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/6/6c/latest/20221107215510/Poliwrath.png"
    ),
    (
        "Abra", "Psíquico", "Puede teletransportarse para escapar de peligros y ataques.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/7/75/latest/20221107215514/Abra.png"
    ),
    (
        "Kadabra", "Psíquico",
        "Posee poderes psíquicos más fuertes y un cuchillo psíquico que usa en combate.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/5/57/latest/20221107215513/Kadabra.png"
    ),
    (
        "Alakazam", "Psíquico",
        "Su coeficiente intelectual es extremadamente alto. Puede mover objetos con la mente.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/8/84/latest/20221107215511/Alakazam.png"
    ),
    (
        "Machop", "Lucha", "Fuerte y resistente, puede levantar pesas muy pesadas.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/4/4b/latest/20221107215511/Machop.png"
    ),
    (
        "Machoke", "Lucha",
        "Su fuerza física es impresionante. Tiene músculos bien desarrollados.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/f/f8/latest/20221107215510/Machoke.png"
    ),
    (
        "Machamp", "Lucha", "Puede lanzar golpes poderosos con sus cuatro brazos.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/c/cd/latest/20221107215511/Machamp.png"
    ),
    (
        "Bellsprout", "Planta/Veneno", "Suelta un líquido pegajoso para atrapar a sus presas.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/7/7c/latest/20221107215510/Bellsprout.png"
    ),
    (
        "Weepinbell", "Planta/Veneno",
        "Usa su liana para atrapar a las presas y absorber nutrientes.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/1/11/latest/20221107215511/Weepinbell.png"
    ),
    (
        "Victreebel", "Planta/Veneno",
        "Su liana puede atrapar presas grandes y su boca segrega jugos digestivos.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/3/37/latest/20221107215512/Victreebel.png"
    ),
    (
        "Tentacool", "Agua/Veneno",
        "Sus tentáculos tienen veneno paralizante. Nada cerca de la costa.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/e/ed/latest/20221107215510/Tentacool.png"
    ),
    (
        "Tentacruel", "Agua/Veneno",
        "Controla a sus tentáculos con gran precisión para atacar.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/a/a1/latest/20221107215511/Tentacruel.png"
    ),
    (
        "Geodude", "Roca/Tierra", "Pequeño y fuerte. Puede rodar colinas para desplazarse.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/c/c2/latest/20221107215510/Geodude.png"
    ),
    (
        "Graveler", "Roca/Tierra", "Sólido y resistente. Puede lanzar rocas a gran velocidad.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/a/a5/latest/20221107215510/Graveler.png"
    ),
    (
        "Golem", "Roca/Tierra",
        "Su cuerpo es duro como una roca. Puede aplastar con facilidad.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/8/85/latest/20221107215510/Golem.png"
    ),
    (
        "Ponyta", "Fuego", "Su crin arde como fuego. Corre muy rápido por praderas.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/e/e7/latest/20221107215512/Ponyta.png"
    ),
    (
        "Rapidash", "Fuego", "Su velocidad es tan alta que puede crear tornados con su galope.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/f/f6/latest/20221107215510/Rapidash.png"
    ),
    (
        "Slowpoke", "Agua/Psíquico", "Suele estar distraído. Puede detectar ondas psíquicas.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/5/58/latest/20221107215509/Slowpoke.png"
    ),
    (
        "Slowbro", "Agua/Psíquico",
        "Vive con un Shellder pegado a la cola, que le da poderes psíquicos.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/f/f2/latest/20221107215511/Slowbro.png"
    ),
    (
        "Magnemite", "Eléctrico/Acero",
        "Flota usando campos magnéticos y emite descargas eléctricas.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/5/5b/latest/20221107215510/Magnemite.png"
    ),
    (
        "Magneton", "Eléctrico/Acero",
        "Tres Magnemite que se unen para aumentar su poder eléctrico.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/0/03/latest/20221107215509/Magneton.png"
    ),
    (
        "Farfetchd", "Normal/Volador", "Usa un tallo de puerro como arma y escudo.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/8/8b/latest/20221107215510/Farfetchd.png"
    ),
    (
        "Doduo", "Normal/Volador", "Tiene dos cabezas y es muy rápido corriendo.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/2/2c/latest/20221107215512/Doduo.png"
    ),
    (
        "Dodrio", "Normal/Volador", "Tres cabezas que cooperan para correr a gran velocidad.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/3/32/latest/20221107215513/Dodrio.png"
    ),
    (
        "Seel", "Agua", "Habita en aguas frías y usa su cuerno para atacar.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/5/54/latest/20221107215510/Seel.png"
    ),
    (
        "Dewgong", "Agua/Hielo", "Combina poder de agua y hielo para defenderse.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/9/9e/latest/20221107215511/Dewgong.png"
    ),
    (
        "Grimer", "Veneno",
        "Se forma en lugares contaminados y desprende un olor desagradable.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/8/8a/latest/20221107215509/Grimer.png"
    ),
    (
        "Muk", "Veneno", "Su cuerpo está compuesto por una masa tóxica que absorbe todo.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/9/9d/latest/20221107215511/Muk.png"
    ),
    (
        "Shellder", "Agua", "Puede cerrar su caparazón para defenderse.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/6/6c/latest/20221107215512/Shellder.png"
    ),
    (
        "Cloyster", "Agua/Hielo",
        "Su caparazón es extremadamente duro y puede lanzar púas afiladas.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/9/9f/latest/20221107215512/Cloyster.png"
    ),
    (
        "Gastly", "Fantasma/Veneno", "Un Pokémon gaseoso que asusta a sus presas.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/e/e0/latest/20221107215511/Gastly.png"
    ),
    (
        "Haunter", "Fantasma/Veneno", "Flota en el aire y usa ataques de gas venenoso.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/2/20/latest/20221107215510/Haunter.png"
    ),
    (
        "Gengar", "Fantasma/Veneno",
        "Muy travieso, puede desaparecer y atacar desde las sombras.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/9/9d/latest/20221107215510/Gengar.png"
    ),
    (
        "Onix", "Roca/Tierra", "Un gigantesco Pokémon serpiente hecho de rocas.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/7/7b/latest/20221107215511/Onix.png"
    ),
    (
        "Drowzee", "Psíquico",
        "Hace que sus presas caigan en sueños para alimentarse de su energía.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/e/e4/latest/20221107215511/Drowzee.png"
    ),
    (
        "Hypno", "Psíquico", "Usa un péndulo para inducir hipnosis.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/d/d6/latest/20221107215512/Hypno.png"
    ),
    (
        "Krabby", "Agua", "Tiene grandes pinzas que usa para defenderse.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/2/2f/latest/20221107215510/Krabby.png"
    ),
    (
        "Kingler", "Agua", "Sus pinzas son muy poderosas y pueden aplastar rocas.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/8/81/latest/20221107215511/Kingler.png"
    ),
    (
        "Voltorb", "Eléctrico",
        "Se parece a una Poké Ball y puede explotar si se siente amenazado.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/a/a0/latest/20221107215512/Voltorb.png"
    ),
    (
        "Electrode", "Eléctrico", "Una Poké Ball viviente que puede explotar a voluntad.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/e/e6/latest/20221107215511/Electrode.png"
    ),
    (
        "Exeggcute", "Planta/Psíquico", "Un grupo de huevos con poderes psíquicos.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/b/b4/latest/20221107215510/Exeggcute.png"
    ),
    (
        "Exeggutor", "Planta/Psíquico", "Tiene varias cabezas y puede usar ataques psíquicos.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/3/30/latest/20221107215511/Exeggutor.png"
    ),
    (
        "Cubone", "Tierra", "Lleva el cráneo de su madre y usa un hueso como arma.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/4/42/latest/20221107215510/Cubone.png"
    ),
    (
        "Marowak", "Tierra", "Usa su hueso con gran fuerza para protegerse.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/1/10/latest/20221107215511/Marowak.png"
    ),
    (
        "Hitmonlee", "Lucha", "Especialista en patadas con gran alcance y fuerza.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/d/d9/latest/20221107215510/Hitmonlee.png"
    ),
    (
        "Hitmonchan", "Lucha", "Maestro en golpes rápidos y potentes.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/a/ab/latest/20221107215511/Hitmonchan.png"
    ),
    (
        "Lickitung", "Normal", "Su lengua larga es capaz de atrapar objetos y atacar.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/d/d8/latest/20221107215510/Lickitung.png"
    ),
    (
        "Koffing", "Veneno", "Libera gases tóxicos para defenderse.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/9/99/latest/20221107215512/Koffing.png"
    ),
    (
        "Weezing", "Veneno", "Libera gases más venenosos y corrosivos.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/1/1b/latest/20221107215511/Weezing.png"
    ),
    (
        "Rhyhorn", "Tierra/Roca",
        "Su cuerpo está cubierto de una piel muy dura que le protege de ataques.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/c/c9/latest/20221107215512/Rhyhorn.png"
    ),
    (
        "Rhydon", "Tierra/Roca", "Con un cuerno afilado, puede atravesar casi cualquier cosa.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/f/f0/latest/20221107215511/Rhydon.png"
    ),
    (
        "Chansey", "Normal", "Es muy cariñosa y cuida de otros Pokémon y personas.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/e/e0/latest/20221107215510/Chansey.png"
    ),
    (
        "Tangela", "Planta", "Está cubierta de enredaderas azules que usa para atacar.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/a/a6/latest/20221107215511/Tangela.png"
    ),
    (
        "Kangaskhan", "Normal",
        "Una madre protectora que siempre lleva a su cría en la bolsa.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/5/59/latest/20221107215510/Kangaskhan.png"
    ),
    (
        "Horsea", "Agua", "Lanza chorros de agua a alta presión para defenderse.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/8/89/latest/20221107215510/Horsea.png"
    ),
    (
        "Seadra", "Agua", "Sus púas afiladas pueden causar heridas profundas.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/e/e8/latest/20221107215511/Seadra.png"
    ),
    (
        "Goldeen", "Agua", "Nada con elegancia y tiene un cuerno afilado para defenderse.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/7/7f/latest/20221107215511/Goldeen.png"
    ),
    (
        "Seaking", "Agua", "Posee un cuerno que usa para luchar y proteger su territorio.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/6/6f/latest/20221107215510/Seaking.png"
    ),
    (
        "Staryu", "Agua", "Se comunica con destellos de su núcleo brillante.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/9/9b/latest/20221107215510/Staryu.png"
    ),
    (
        "Starmie", "Agua/Psíquico", "Su núcleo brillante es una fuente de energía misteriosa.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/8/85/latest/20221107215510/Starmie.png"
    ),
    (
        "Mr. Mime", "Psíquico/Hada",
        "Puede crear barreras invisibles y es muy hábil en la pantomima.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/6/60/latest/20221107215510/Mr._Mime.png"
    ),
    (
        "Scyther", "Bicho/Volador",
        "Muy rápido y con afiladas garras que corta con facilidad.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/f/f2/latest/20221107215510/Scyther.png"
    ),
    (
        "Jynx", "Hielo/Psíquico",
        "Usa ataques de hielo y poderes psíquicos para confundir a sus enemigos.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/f/f1/latest/20221107215511/Jynx.png"
    ),
    (
        "Electabuzz", "Eléctrico", "Genera electricidad estática para atacar con descargas.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/7/75/latest/20221107215511/Electabuzz.png"
    ),
    (
        "Magmar", "Fuego", "Su cuerpo está envuelto en llamas, genera calor intenso.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/6/68/latest/20221107215510/Magmar.png"
    ),
    (
        "Pinsir", "Bicho", "Sus grandes pinzas pueden aplastar a sus enemigos.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/9/90/latest/20221107215510/Pinsir.png"
    ),
    (
        "Tauros", "Normal", "Un toro salvaje muy agresivo y fuerte.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/e/e6/latest/20221107215511/Tauros.png"
    ),
    (
        "Magikarp", "Agua", "Aunque débil, puede evolucionar en un poderoso Pokémon.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/f/f9/latest/20221107215510/Magikarp.png"
    ),
    (
        "Gyarados", "Agua/Volador", "Temible y agresivo, puede causar gran destrucción.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/f/f4/latest/20221107215510/Gyarados.png"
    ),
    (
        "Lapras", "Agua/Hielo",
        "Amable y inteligente, usado para transportar personas por el agua.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/f/f7/latest/20221107215510/Lapras.png"
    ),
    (
        "Ditto", "Normal", "Puede transformarse en cualquier otro Pokémon.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/0/0f/latest/20221107215511/Ditto.png"
    ),
    (
        "Eevee", "Normal", "Con múltiples posibles evoluciones, es muy adaptable.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/0/01/latest/20221107215511/Eevee.png"
    ),
    (
        "Vaporeon", "Agua", "Evolución acuática de Eevee con cuerpo acuoso.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/9/9c/latest/20221107215511/Vaporeon.png"
    ),
    (
        "Jolteon", "Eléctrico", "Evolución eléctrica de Eevee, rápido y con púas eléctricas.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/6/64/latest/20221107215511/Jolteon.png"
    ),
    (
        "Flareon", "Fuego", "Evolución de fuego de Eevee, con pelaje ardiente.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/0/01/latest/20221107215511/Flareon.png"
    ),
    (
        "Porygon", "Normal", "Un Pokémon virtual hecho de datos digitales.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/4/4e/latest/20221107215511/Porygon.png"
    ),
    (
        "Omanyte", "Roca/Agua", "Un fósil que revive, protegido por un caparazón duro.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/3/31/latest/20221107215511/Omanyte.png"
    ),
    (
        "Omastar", "Roca/Agua", "Evolución de Omanyte, con pinzas fuertes.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/c/c2/latest/20221107215511/Omastar.png"
    ),
    (
        "Kabuto", "Roca/Agua", "Un Pokémon fósil con un caparazón resistente.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/d/d8/latest/20221107215511/Kabuto.png"
    ),
    (
        "Kabutops", "Roca/Agua", "Evolución de Kabuto, con afiladas hojas en lugar de brazos.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/0/0b/latest/20221107215511/Kabutops.png"
    ),
    (
        "Aerodactyl", "Roca/Volador", "Un Pokémon fósil muy rápido y agresivo.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/4/40/latest/20221107215511/Aerodactyl.png"
    ),
    (
        "Snorlax", "Normal", "Duerme todo el día y solo se despierta para comer.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/5/5d/latest/20221107215511/Snorlax.png"
    ),
    (
        "Articuno", "Hielo/Volador", "Un legendario pájaro de hielo con grandes poderes.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/0/0d/latest/20221107215511/Articuno.png"
    ),
    (
        "Zapdos", "Eléctrico/Volador", "Un legendario pájaro con control de electricidad.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/3/35/latest/20221107215511/Zapdos.png"
    ),
    (
        "Moltres", "Fuego/Volador", "Un legendario pájaro de fuego con llamas eternas.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/6/6b/latest/20221107215511/Moltres.png"
    ),
    (
        "Dratini", "Dragón", "Un Pokémon dragón en su forma juvenil.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/f/f2/latest/20221107215511/Dratini.png"
    ),
    (
        "Dragonair", "Dragón", "Evolución de Dratini, con poderes místicos.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/4/41/latest/20221107215511/Dragonair.png"
    ),
    (
        "Dragonite", "Dragón/Volador", "Forma final de Dratini, muy fuerte y rápido.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/2/2c/latest/20221107215511/Dragonite.png"
    ),
    (
        "Mewtwo", "Psíquico", "Un Pokémon legendario creado por ingeniería genética.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/9/90/latest/20221107215511/Mewtwo.png"
    ),
    (
        "Mew", "Psíquico", "Un Pokémon legendario muy raro y poderoso.",
        "https://images.wikidexcdn.net/mwuploads/wikidex/4/43/latest/20221107215511/Mew.png"
    ),
]
