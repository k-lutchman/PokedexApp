import Foundation

struct PokemonListItem {
    let name: String
    let url: String
    
    var id: Int {
        let components = url.split(separator: "/")
        if let idString = components.last(where: { !$0.isEmpty }),
           let id = Int(idString) {
            return id
        }
        return 0
    }
    
    var imageUrl: String {
        return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png"
    }
}
