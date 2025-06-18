import UIKit

class PokemonTableViewCell: UITableViewCell {
    
    let pokemonImageView = UIImageView()
    let numberLabel = UILabel()
    let nameLabel = UILabel()
    private let labelsStackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(pokemonImageView)
        contentView.addSubview(labelsStackView)
        
        pokemonImageView.translatesAutoresizingMaskIntoConstraints = false
        pokemonImageView.contentMode = .scaleAspectFit
        
        numberLabel.font = UIFont.systemFont(ofSize: 16)
        numberLabel.textAlignment = .right
        
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.textAlignment = .left
        
        labelsStackView.axis = .horizontal
        labelsStackView.alignment = .center
        labelsStackView.distribution = .fill
        labelsStackView.spacing = 8
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        labelsStackView.addArrangedSubview(numberLabel)
        labelsStackView.addArrangedSubview(nameLabel)
        
        numberLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        NSLayoutConstraint.activate([
            pokemonImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            pokemonImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            pokemonImageView.widthAnchor.constraint(equalToConstant: 80),
            pokemonImageView.heightAnchor.constraint(equalToConstant: 80),
            pokemonImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            labelsStackView.leadingAnchor.constraint(equalTo: pokemonImageView.trailingAnchor, constant: 16),
            labelsStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            labelsStackView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),
            labelsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
    }
    
    func configure(with pokemon: PokemonListItem) {
        numberLabel.text = "#\(pokemon.id)"
        nameLabel.text = pokemon.name.capitalized
        
        if let url = URL(string: pokemon.imageUrl) {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        self?.pokemonImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }
}
