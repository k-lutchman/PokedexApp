import Foundation

class APIService {
    
    static let shared = APIService()
    private init() {}
    
    // 151 Pokémon.
    func fetchPokemonList(completion: @escaping (Result<[PokemonListItem], Error>) -> Void) {
        let urlString = "https://pokeapi.co/api/v2/pokemon?limit=151"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "APIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL."])))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "APIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data returned."])))
                return
            }
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(PokemonListResponse.self, from: data)
                let items = response.results.map { PokemonListItem(name: $0.name, url: $0.url) }
                completion(.success(items))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchPokemonSpecies(id: Int, completion: @escaping (Result<PokemonSpecies, Error>) -> Void) {
        let urlString = "https://pokeapi.co/api/v2/pokemon-species/\(id)/"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "APIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL."])))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "APIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data returned."])))
                return
            }
            do {
                let decoder = JSONDecoder()
                let species = try decoder.decode(PokemonSpecies.self, from: data)
                completion(.success(species))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
