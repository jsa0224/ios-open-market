//
//  EmptyViewController.swift
//  OpenMarket
//
//  Created by Ash and som on 2022/11/27.
//

import UIKit

final class AddItemViewController: ItemViewController {
    private let addItemView = ItemView()
    private var productImages: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        super.configureNavigationBar(title: OpenMarketNaviItem.addItemTitle)
        addItemView.isHiddenImage()
        configureImagePicker()
    }
    
    override func loadView() {
        self.view = addItemView
    }
    
    @objc internal override func tappedDone(sender: UIBarButtonItem) {
        guard addItemView.nameTextCount >= 3 else {
            showAlertController(title: OpenMarketAlert.productTextLimit,
                                message: OpenMarketAlert.productTextLimitMessage)
            return
        }
        
        guard 1 <= addItemView.descTextCount && addItemView.descTextCount <= 1000 else {
            showAlertController(title: OpenMarketAlert.descTextLimit,
                                message: OpenMarketAlert.descTextLimitMessage)
            return
        }
        
        guard addItemView.priceText.isEmpty == false else {
            showAlertController(title: OpenMarketAlert.priceEmpty,
                                message: OpenMarketAlert.priceEmptyMessage)
            return
        }
        
        postItemDatas()
        
        self.navigationController?.popViewController(animated: true)
    }
    
    private func postItemDatas() {
        guard let encodingData = JSONConverter.shared.encodeJson(param: addItemView.transferData()) else {
            return
        }

        Task {
            try await HTTPManager.shared.requestPost(url: OpenMarketURL.postProductComponent.url,
                                                                encodingData: encodingData,
                                                                images: productImages)
        }
    }
}

extension AddItemViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func configureImagePicker() {
        self.addItemView.registrationButton.addTarget(self,
                                                      action: #selector(showImagePicker),
                                                      for: .touchUpInside)
    }
    
    @objc func showImagePicker() {
        guard productImages.count <= 4 else {
            showAlertController(title: OpenMarketAlert.imageLimit,
                                message: OpenMarketAlert.imageLimitMessage)
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let lastIndex = productImages.count
        
        if let image = info[.editedImage] as? UIImage, productImages.isEmpty {
            self.addItemView.imageStackView.insertArrangedSubview(UIImageView(image: image), at: 0)
            self.productImages.append(image)
        } else if let image = info[.editedImage] as? UIImage, productImages.isEmpty == false {
            self.addItemView.imageStackView.insertArrangedSubview(UIImageView(image: image), at: lastIndex)
            self.productImages.append(image)
        }
        
        dismiss(animated: true)
    }
}
