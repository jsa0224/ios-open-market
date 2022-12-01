//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

@available(iOS 14.0, *)
final class MainViewController: UIViewController {
    var product: Item?
    var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
    var listDataSource: UICollectionViewDiffableDataSource<Section, Item>! = nil
    var gridDataSource: UICollectionViewDiffableDataSource<Section, Item>! = nil
    var collectionView: UICollectionView! = nil
    
    enum Section {
        case main
    }
    
    enum Menu {
        case list
        case grid
        
        var option: Int {
            switch self {
            case .list:
                return 0
            case .grid:
                return 1
            }
        }
        
        var description: String {
            switch self {
            case .list:
                return "List"
            case .grid:
                return "Grid"
            }
        }
    }
    
    let segmentedControl: UISegmentedControl = UISegmentedControl(items: [Menu.list.description, Menu.grid.description])
    lazy var plusButton = UIBarButtonItem(image: UIImage(systemName: OpenMarketImage.plus),
                                     style: .plain,
                                     target: self,
                                     action: #selector(tapped(sender:)))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNaviBarItem()
        configureHierarchy()
        configureDataSource()
        getItemList()
        
        let som = Param(name: "아이브 장원영", welcomeDescription: "하모가 올려달래요 ㅎㅎ", price: 100000000000, currency: "KRW", discountedPrice: 0, stock: 0, secret: "jbb2dy6r65tkgn3q")
        let item = JSONConverter.shared.encodeJson(param: som)
        
        HTTPManager.shared.requestPOST(url: "https://openmarket.yagom-academy.kr/api/products", encodingData: item!) { data in
            print("완료!")
        }
    }
    
    private func configureNaviBarItem() {
        configureSegment()
        configurePlusButton()
    }
    
    private func configureDataSource() {
        configureGridDataSource()
        configureListDataSource()
    }
    
    private func getItemList() {
        let url = OpenMarketURL.itemPageComponent(pageNo: 1, itemPerPage: 100).url
        
        NetworkManager.publicNetworkManager.getJSONData(
            url: url,
            type: ItemList.self) { itemData in
                self.makeSnapshot(itemData: itemData)
            }
    }
    
    private func makeSnapshot(itemData: ItemList) {
        snapshot.appendSections([.main])
        snapshot.appendItems(itemData.pages)
        listDataSource.apply(snapshot, animatingDifferences: false)
        gridDataSource.apply(snapshot, animatingDifferences: false)
    }
}

@available(iOS 14.0, *)
extension MainViewController {
    private func configureSegment() {
        self.navigationItem.titleView = segmentedControl
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.systemBlue], for: .normal)
        segmentedControl.selectedSegmentTintColor = .systemBlue
        segmentedControl.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        segmentedControl.layer.borderWidth = 1.0
        segmentedControl.layer.borderColor = UIColor.systemBlue.cgColor
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(didChangeValue(segment:)), for: .valueChanged)
    }
    
    private func configurePlusButton() {
        self.navigationItem.rightBarButtonItem = plusButton
    }
    
    @objc private func didChangeValue(segment: UISegmentedControl) {
        let selection = segment.selectedSegmentIndex
        switch selection {
        case Menu.list.option:
            collectionView.dataSource = listDataSource
            collectionView.setCollectionViewLayout(createListLayout(), animated: true)
        case Menu.grid.option:
            collectionView.dataSource = gridDataSource
            collectionView.setCollectionViewLayout(createGridLayout(), animated: true)
        default:
            break
        }
    }
    
    @objc private func tapped(sender: UIBarButtonItem) {
        let emptyViewController = EmptyViewController()
        
        emptyViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        
        self.present(emptyViewController, animated: true)
    }
}

@available(iOS 14.0, *)
extension MainViewController {
    private func createListLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.09))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createListLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(collectionView)
    }
    
    private func configureListDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell, Item> { (cell, indexPath, item) in
            cell.configureContent(item: item)
        }
        
        listDataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Item) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }
}

@available(iOS 14.0, *)
extension MainViewController {
    private func createGridLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func configureGridDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<GridCollectionViewCell, Item> { (cell, indexPath, item) in
            cell.configureContent(item: item)
        }
        
        gridDataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Item) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }
}
