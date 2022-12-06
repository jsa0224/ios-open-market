//
//  EmptyViewController.swift
//  OpenMarket
//
//  Created by Ash and som on 2022/11/27.
//

import UIKit

final class AddItemViewController: UIViewController {
    let addItemView = AddItemView()
    var productImages: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureNavigationBar()
        configureLayout()
        configureImagePicker()
    }
    
    private func configureNavigationBar() {
        self.title = "상품등록"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                                style: .plain,
                                                                target: self, action:
                                                                    #selector(tappedCancel(sender:)))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done",
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(tappedDone(sender:)))
    }
    
    @objc private func tappedCancel(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func tappedDone(sender: UIBarButtonItem) {
        
    }
}

extension AddItemViewController {
    func configureLayout() {
        self.view.addSubview(addItemView)
        
        addItemView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addItemView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            addItemView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            addItemView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            addItemView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension AddItemViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func configureImagePicker() {
        self.addItemView.registrationButton.addTarget(self, action: #selector(showImagePicker), for: .touchUpInside)
    }
    
    @objc func showImagePicker() {
        guard productImages.count <= 4 else {
            showAlertController(title: "이미지 등록 불가", message: "이미지는 5개까지 등록이 가능합니다.")
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

extension AddItemViewController {
    func showAlertController(title: String, message: String) {
        let alert: UIAlertController = UIAlertController(title: "\(title)",
                                                         message: "\(message)",
                                                         preferredStyle: .alert)
        
        let action: UIAlertAction = UIAlertAction(title: "확인",
                                                  style: .default,
                                                  handler: nil)
        
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}
