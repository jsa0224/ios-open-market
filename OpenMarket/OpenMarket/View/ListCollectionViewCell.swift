//
//  ListCollectionViewCell.swift
//  OpenMarket
//
//  Created by Ash and som on 2022/11/22.
//

import UIKit

final class ListCollectionViewCell: UICollectionViewCell {
    var product: Item?
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 10
        
        return stackView
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        
        return stackView
    }()
    
    private let priceStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.axis = .horizontal
        
        return stackView
    }()
    
    private var accessoryView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: OpenMarketImage.cross)
        imageView.tintColor = .systemGray
        
        return imageView
    }()

    private let productImage: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 20)
        
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        
        return label
    }()
    
    private let priceForSaleLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        
        return label
    }()
    
    private let stockLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        
        return label
    }()
    
    private let spacingView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configurePriority()
        configureLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configurePriority() {
        let priceHuggingPriority = priceForSaleLabel.contentHuggingPriority(for: .horizontal) + 1
        let stockHuggingPriority = productNameLabel.contentHuggingPriority(for: .horizontal) + 1
        let stockCompressionPriority = productNameLabel.contentCompressionResistancePriority(for: .horizontal) + 1
        
        stockLabel.setContentHuggingPriority(stockHuggingPriority, for: .horizontal)
        stockLabel.setContentCompressionResistancePriority(stockCompressionPriority, for: .horizontal)
        priceLabel.setContentHuggingPriority(priceHuggingPriority, for: .horizontal)
        spacingView.setContentHuggingPriority(priceHuggingPriority, for: .horizontal)
    }
    
    private func configureLayout() {
        contentView.addSubview(loadingView)
        contentView.addSubview(productImage)
        contentView.addSubview(mainStackView)
        labelStackView.addArrangedSubview(productNameLabel)
        labelStackView.addArrangedSubview(stockLabel)
        labelStackView.addArrangedSubview(accessoryView)
        mainStackView.addArrangedSubview(labelStackView)
        mainStackView.addArrangedSubview(priceStackView)
        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(spacingView)
        priceStackView.addArrangedSubview(priceForSaleLabel)
        
        NSLayoutConstraint.activate([
            loadingView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5),
            loadingView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            loadingView.heightAnchor.constraint(equalToConstant: 70),
            loadingView.widthAnchor.constraint(equalToConstant: 70),
            
            productImage.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5),
            productImage.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            productImage.heightAnchor.constraint(equalToConstant: 70),
            productImage.widthAnchor.constraint(equalToConstant: 70),
            
            mainStackView.leadingAnchor.constraint(equalTo: productImage.trailingAnchor, constant: 10),
            mainStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15),
            mainStackView.centerYAnchor.constraint(equalTo: productImage.centerYAnchor),
            
            productNameLabel.leadingAnchor.constraint(equalTo: priceStackView.leadingAnchor),
            stockLabel.leadingAnchor.constraint(equalTo: productNameLabel.trailingAnchor, constant: 5),
            stockLabel.trailingAnchor.constraint(equalTo: accessoryView.leadingAnchor, constant: -5),
            
            accessoryView.heightAnchor.constraint(equalToConstant: 17),
            accessoryView.widthAnchor.constraint(equalTo: accessoryView.heightAnchor),
            
            spacingView.widthAnchor.constraint(equalToConstant: 6)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImage.image = nil
        loadingView.startAnimating()
        loadingView.isHidden = false
    }
    
    func configureContent(item: Item) {
        self.product = item
        
        configureItemLabel(item: item)
        configureItemImage(item: item)
    }
    
    private func configureItemImage(item: Item) {
        Task {
            guard let image = try await NetworkManager.publicNetworkManager.getImageData(url: item.thumbnail) else { return }

            if item == product {
                productImage.image = image
                loadingView.stopAnimating()
                loadingView.isHidden = true
            }
        }
    }

    private func configureItemLabel(item: Item) {
        var priceForSale: String
        var priceToString: String
        var stock: String
        
        do {
            let discountPrice = item.price - item.discountedPrice
            priceToString = try item.price.formatDouble
            priceForSale = try discountPrice.formatDouble
            stock = try item.stock.formatInt
        } catch {
            priceToString = OpenMarketStatus.noneError
            priceForSale = OpenMarketStatus.noneError
            stock = OpenMarketStatus.noneError
        }
        
        productNameLabel.text = item.name
        priceLabel.text = .none
        priceLabel.attributedText = .none
        stockLabel.text = OpenMarketDataText.stock + stock
        stockLabel.textColor = .systemGray
        priceForSaleLabel.text = "\(item.currency.rawValue) \(priceForSale)"
        priceForSaleLabel.textColor = .systemGray
        
        if item.bargainPrice != item.price {
            priceLabel.isHidden = false
            priceForSaleLabel.text = "\(item.currency.rawValue) \(priceForSale)"
            priceLabel.textColor = .systemRed
            priceLabel.text = "\(item.currency.rawValue) \(priceToString)"
            
            guard let priceText = priceLabel.text else { return }
            let attribute = NSMutableAttributedString(string: priceText)
            attribute.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attribute.length))
            priceLabel.attributedText = attribute
            priceForSaleLabel.textColor = .systemGray
        }
        
        if item.stock == 0 {
            stockLabel.text = OpenMarketDataText.soldOut
            stockLabel.textColor = .systemYellow
        }
    }
}
