//
//  EditItemViewController.swift
//  OpenMarket
//
//  Created by Ash and som on 2022/12/07.
//

import UIKit

final class EditItemViewController: ItemViewController {
    let editItemView = ItemView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        super.configureNavigationBar(title: OpenMarketNaviItem.editItemTitle)
    }
    
    override func loadView() {
        self.view = editItemView
    }
    
    func getItemList(id: Int) {
        Task {
            let url = OpenMarketURL.productComponent(productID: id).url

            guard let data = try? await NetworkManager.publicNetworkManager.getJSONData(url: url, type: Item.self) else { return }

            self.editItemView.configureItemLabel(data: data)
        }
    }
}
