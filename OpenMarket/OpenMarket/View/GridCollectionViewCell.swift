//
//  GridCollectionViewCell.swift
//  OpenMarket
//
//  Created by Ash and som on 2022/11/22.
//

import UIKit

final class GridCollectionViewCell: UICollectionViewCell {
    var product: Item?
    
    private let verticalStackView = UIStackView()
    private let titleLabel = UILabel()
    private let itemImageView = UIImageView()
    private let priceLabel = UILabel()
    private let discountedLabel = UILabel()
    private let stockLabel = UILabel()
    private let loadingView = UIActivityIndicatorView(style: .large)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAttribute()
        configureLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureAttribute() {
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        discountedLabel.translatesAutoresizingMaskIntoConstraints = false
        stockLabel.translatesAutoresizingMaskIntoConstraints = false
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        verticalStackView.distribution = .equalSpacing
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 5
        loadingView.contentMode = .scaleAspectFill
        itemImageView.contentMode = .scaleAspectFit
        
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        priceLabel.textAlignment = .center
        priceLabel.isHidden = true
        discountedLabel.textAlignment = .center
        stockLabel.textAlignment = .center
    }
    
    private func configureLayout() {
        self.contentView.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(loadingView)
        verticalStackView.addArrangedSubview(itemImageView)
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(priceLabel)
        verticalStackView.addArrangedSubview(discountedLabel)
        verticalStackView.addArrangedSubview(stockLabel)
        
        NSLayoutConstraint.activate([
            itemImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            loadingView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            
            verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        itemImageView.image = nil
        loadingView.startAnimating()
        loadingView.isHidden = false
    }
    
    func configureContent(item: Item) {
        self.product = item
        
        priceLabel.text = .none
        priceLabel.attributedText = .none
        titleLabel.text = "\(item.name)"
        stockLabel.text = "잔여수량: \(item.stock)"
        stockLabel.textColor = .systemGray
        discountedLabel.text = "\(item.currency) \(item.discountedPrice)"
        discountedLabel.textColor = .systemGray
        
        if item.bargainPrice != 0 {
            priceLabel.isHidden = false
            discountedLabel.text = "\(item.currency) \(item.discountedPrice)"
            priceLabel.textColor = .systemRed
            priceLabel.text = "\(item.currency) \(item.price)"
            
            guard let priceText = priceLabel.text else { return }
            let attribute = NSMutableAttributedString(string: priceText)
            attribute.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attribute.length))
            priceLabel.attributedText = attribute
            discountedLabel.textColor = .systemGray
        }
        
        if item.stock == 0 {
            stockLabel.text = "품절"
            stockLabel.textColor = .systemYellow
        }
        
        DispatchQueue.global().async {
            guard let url = URL(string: item.thumbnail) else { return }
            
            NetworkManager().getImageData(url: url) { image in
                DispatchQueue.main.async {
                    if item == self.product {
                        self.itemImageView.image = image
                        self.loadingView.stopAnimating()
                        self.loadingView.isHidden = true
                    }
                }
            }
        }
        
        layer.cornerRadius = 10.0
        layer.borderColor = UIColor.systemGray.cgColor
        layer.borderWidth = 1
    }
}
