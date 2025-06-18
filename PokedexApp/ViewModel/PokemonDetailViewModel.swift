import Foundation

class PokemonDetailViewModel {
    let pokemon: PokemonListItem
    var descriptionText: String?
    
    init(pokemon: PokemonListItem) {
        self.pokemon = pokemon
    }
    
    func fetchPokemonDescription(completion: @escaping (Error?) -> Void) {
        APIService.shared.fetchPokemonSpecies(id: pokemon.id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let species):
                    if let entry = species.flavor_text_entries.first(where: { $0.language.name == "en" }) {
                        self?.descriptionText = entry.flavor_text.replacingOccurrences(of: "\n", with: " ")
                        completion(nil)
                    } else {
                        completion(nil)
                    }
                case .failure(let error):
                    completion(error)
                }
            }
        }
    }
}
