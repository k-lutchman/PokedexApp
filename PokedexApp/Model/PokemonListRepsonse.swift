import Foundation

struct PokemonListResponse: Codable {
    let results: [PokemonAPIItem]
}

struct PokemonAPIItem: Codable {
    let name: String
    let url: String
}
