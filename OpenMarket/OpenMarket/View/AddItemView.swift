//
//  AddItemView.swift
//  OpenMarket
//
//  Created by Ash and som on 2022/12/05.
//

import UIKit

final class AddItemView: UIView {
    private let imageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        
        return scrollView
    }()
    
    var imageStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private let priceStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5
        stackView.axis = .horizontal
        stackView.distribution = .fill
        
        return stackView
    }()
    
    let productBackgroundView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray5
        
        return view
    }()
    
    var registrationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        return button
    }()
    
    let productNameTextField: UITextField = {
        let textField = UITextField()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.placeholder = "상품명"
        
        return textField
    }()
    
    let priceTextField: UITextField = {
        let textField = UITextField()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.placeholder = "상품가격"
        
        return textField
    }()
    
    let priceForSaleTextField: UITextField = {
        let textField = UITextField()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.placeholder = "할인금액"
        
        return textField
    }()
    
    let stockTextField: UITextField = {
        let textField = UITextField()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.placeholder = "재고수량"
        
        return textField
    }()
    
    let currencySegmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["KRW", "USD"])
        
        control.translatesAutoresizingMaskIntoConstraints = false
        control.selectedSegmentIndex = 0
        
        
        return control
    }()
    
    let descTextView: UITextView = {
        let textView = UITextView()
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.systemGray5.cgColor
        textView.layer.cornerRadius = 5
        textView.textColor = .systemGray3
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        self.addSubview(imageScrollView)
        self.addSubview(labelStackView)
        self.addSubview(descTextView)
        
        descTextView.delegate = self

        descTextView.text = OpenMarketDataText.textViewPlaceHolder
        
        imageScrollView.addSubview(imageStackView)
        
        imageStackView.addArrangedSubview(productBackgroundView)
        productBackgroundView.addSubview(registrationButton)
        
        labelStackView.addArrangedSubview(productNameTextField)
        labelStackView.addArrangedSubview(priceStackView)
        labelStackView.addArrangedSubview(priceForSaleTextField)
        labelStackView.addArrangedSubview(stockTextField)
        
        priceStackView.addArrangedSubview(priceTextField)
        priceStackView.addArrangedSubview(currencySegmentControl)
        
        NSLayoutConstraint.activate([
            imageScrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            imageScrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            imageScrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            imageScrollView.bottomAnchor.constraint(equalTo: descTextView.topAnchor, constant: -10),
            
            imageStackView.leadingAnchor.constraint(equalTo: imageScrollView.leadingAnchor),
            imageStackView.trailingAnchor.constraint(equalTo: imageScrollView.trailingAnchor),
            imageStackView.topAnchor.constraint(equalTo: imageScrollView.topAnchor),
            imageStackView.bottomAnchor.constraint(equalTo: imageScrollView.bottomAnchor),
            
            productBackgroundView.heightAnchor.constraint(equalToConstant: 150),
            productBackgroundView.widthAnchor.constraint(equalToConstant: 150),
            
            labelStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            labelStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            labelStackView.topAnchor.constraint(equalTo: imageStackView.bottomAnchor, constant: 10),
            labelStackView.bottomAnchor.constraint(equalTo: descTextView.topAnchor, constant: -10),
            
            descTextView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            descTextView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            descTextView.topAnchor.constraint(equalTo: labelStackView.bottomAnchor, constant: 10),
            descTextView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            
            registrationButton.centerXAnchor.constraint(equalTo: productBackgroundView.centerXAnchor),
            registrationButton.centerYAnchor.constraint(equalTo: productBackgroundView.centerYAnchor)
        ])
    }
}

extension AddItemView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == OpenMarketDataText.textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }
}
