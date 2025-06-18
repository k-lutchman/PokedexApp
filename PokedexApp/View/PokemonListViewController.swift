import UIKit

class PokemonListViewController: UIViewController {
    private let tableView = UITableView()
    private let viewModel = PokemonListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pokedex"
        view.backgroundColor = .white
        setupTableView()
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateCellsFade()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.register(PokemonTableViewCell.self, forCellReuseIdentifier: "PokemonCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.backgroundColor = .systemGroupedBackground
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func fetchData() {
        viewModel.fetchPokemonList { [weak self] error in
            if let error = error {
                print("Error fetching Pokémon: \(error)")
            } else {
                self?.tableView.reloadData()
            }
        }
    }
    
    private func updateCellsFade() {
        let topBoundary = view.safeAreaInsets.top
        let bottomBoundary = view.bounds.height - view.safeAreaInsets.bottom
        
        let fadeDistance: CGFloat = 50
        
        for cell in tableView.visibleCells {
            let cellFrame = cell.convert(cell.bounds, to: view)
            let cellCenterY = cellFrame.midY
            
            let topFactor = (cellCenterY - topBoundary) / fadeDistance
            let bottomFactor = (bottomBoundary - cellCenterY) / fadeDistance
            
            
            let clampedTop = max(0, min(1, topFactor))
            let clampedBottom = max(0, min(1, bottomFactor))
            
            
            cell.alpha = min(clampedTop, clampedBottom)
        }
    }
}


extension PokemonListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.pokemonItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath) as? PokemonTableViewCell else {
            return UITableViewCell()
        }
        let pokemon = viewModel.pokemonItems[indexPath.row]
        cell.configure(with: pokemon)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let pokemon = viewModel.pokemonItems[indexPath.row]
        let detailVM = PokemonDetailViewModel(pokemon: pokemon)
        let detailVC = PokemonDetailViewController(viewModel: detailVM)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateCellsFade()
    }
}

