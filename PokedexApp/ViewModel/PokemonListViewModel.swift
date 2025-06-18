import Foundation

class PokemonListViewModel {
    var pokemonItems: [PokemonListItem] = []
    
    func fetchPokemonList(completion: @escaping (Error?) -> Void) {
        APIService.shared.fetchPokemonList { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let items):
                    self?.pokemonItems = items
                    completion(nil)
                case .failure(let error):
                    completion(error)
                }
            }
        }
    }
}
