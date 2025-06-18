import UIKit

class PokemonDetailViewController: UIViewController {
    
    private let viewModel: PokemonDetailViewModel
    private var collectionView: UICollectionView!
    
    init(viewModel: PokemonDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.pokemon.name.capitalized
        view.backgroundColor = .white
        setupCollectionView()
        fetchData()
        
        // Error handling example
        do {
            try simulateErrorDemo()
        } catch {
            showErrorAlert(title: "Maintenance Error", message: error.localizedDescription)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateCellsFade()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCell")
        collectionView.register(NameCollectionViewCell.self, forCellWithReuseIdentifier: "NameCell")
        collectionView.register(DescriptionCollectionViewCell.self, forCellWithReuseIdentifier: "DescriptionCell")
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func fetchData() {
        viewModel.fetchPokemonDescription { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.showErrorAlert(title: "Error", message: error.localizedDescription)
                } else {
                    self?.collectionView.reloadData()
                }
            }
        }
    }
    
    // Error handling example
    private func simulateErrorDemo() throws {
        try performMaintenanceTask()
        print("Maintenance task completed successfully.")
    }
    
    // Error handling example
    private func performMaintenanceTask() throws {
        throw NSError(domain: "com.example.maintenance", code: 100, userInfo: [NSLocalizedDescriptionKey: "Maintenance task failed."])
    }
    
    // Error elert example
    private func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default))
        present(alert, animated: true)
    }
    
    private func updateCellsFade() {
        let fadeDistance: CGFloat = 50
        let safeTop = view.safeAreaInsets.top
        let safeBottom = view.bounds.height - view.safeAreaInsets.bottom
        
        for cell in collectionView.visibleCells {
            let cellFrame = cell.convert(cell.bounds, to: view)
            let cellCenterY = cellFrame.midY
            
            let topFactor: CGFloat = cellCenterY < safeTop + fadeDistance ? (cellCenterY - safeTop) / fadeDistance : 1.0
            let bottomFactor: CGFloat = cellCenterY > safeBottom - fadeDistance ? (safeBottom - cellCenterY) / fadeDistance : 1.0
            
            cell.alpha = min(topFactor, bottomFactor)
        }
    }
}

extension PokemonDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCollectionViewCell
            cell.configure(imageUrl: viewModel.pokemon.imageUrl)
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NameCell", for: indexPath) as! NameCollectionViewCell
            cell.configure(text: viewModel.pokemon.name.capitalized)
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescriptionCell", for: indexPath) as! DescriptionCollectionViewCell
            cell.configure(text: viewModel.descriptionText ?? "Description not available")
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 32
        switch indexPath.item {
        case 0:
            return CGSize(width: width, height: 200)
        case 1:
            return CGSize(width: width, height: 40)
        case 2:
            return CGSize(width: width, height: 100)
        default:
            return CGSize(width: width, height: 50)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateCellsFade()
    }
}

class ImageCollectionViewCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(imageUrl: String) {
        if let url = URL(string: imageUrl) {
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                if let error = error {
                    print("Image fetch error: \(error.localizedDescription)")
                    return
                }
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.imageView.image = image
                    }
                }
            }.resume()
        }
    }
}

class NameCollectionViewCell: UICollectionViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.text = "Name:"
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            valueLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            valueLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            valueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(text: String) {
        valueLabel.text = text
    }
}

class DescriptionCollectionViewCell: UICollectionViewCell {
    private let combinedLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontSizeToFitWidth = false
        label.minimumScaleFactor = 1.0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(combinedLabel)
        NSLayoutConstraint.activate([
            combinedLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            combinedLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            combinedLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            combinedLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(text: String) {
        let header = "Description: "
        let normalizedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let displayText = normalizedText.isEmpty ? "Description not available" : normalizedText
        let fullText = header + displayText
        let font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.hyphenationFactor = 0.0
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .paragraphStyle: paragraphStyle
        ]
        
        let attrString = NSAttributedString(string: fullText, attributes: attributes)
        combinedLabel.attributedText = attrString
    }
}
