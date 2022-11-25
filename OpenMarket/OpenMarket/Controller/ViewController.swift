//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

@available(iOS 15.0, *)
final class ViewController: UIViewController {
    var product: Item?
    var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
    var listDataSource: UICollectionViewDiffableDataSource<Section, Item>! = nil
    var gridDataSource: UICollectionViewDiffableDataSource<Section, Item>! = nil
    var collectionView: UICollectionView! = nil
    
    lazy var emptyView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .white
        view.isHidden = true

        return view
    }()
    
    enum Section {
        case main
    }
    
    let segmentedControl: UISegmentedControl = UISegmentedControl(items: ["List", "Grid"])
    
    let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(tapped(sender:)))
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getItemList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSegment()
        setNavigationItem()
        configureGridHierarchy()
        configureListHierarchy()
        self.view.addSubview(collectionView)
        self.view.addSubview(emptyView)
        configureGridDataSource()
        configureListDataSource()
    }
    
    private func getItemList() {
        let url = OpenMarketURL.base + OpenMarketURLComponent.itemPageComponent(pageNo: 1, itemPerPage: 100).url
        
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
    
    private func setNavigationItem() {
        self.navigationItem.rightBarButtonItem = plusButton
    }
    
    @objc private func tapped(sender: UIBarButtonItem) {
        emptyView.isHidden = false
    }
}

@available(iOS 15.0, *)
extension ViewController {
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
    
    @objc private func didChangeValue(segment: UISegmentedControl) {
        let selection = segment.selectedSegmentIndex
        switch selection {
        case 0:
            collectionView.dataSource = listDataSource
            collectionView.setCollectionViewLayout(createListLayout(), animated: true)
        case 1:
            collectionView.dataSource = gridDataSource
            collectionView.setCollectionViewLayout(createGridLayout(), animated: true)
        default:
            break
        }
    }
}


@available(iOS 15.0, *)
extension ViewController {
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
    
    private func configureListHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createListLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
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

@available(iOS 15.0, *)
extension ViewController {
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
    
    private func configureGridHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createGridLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
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

@available(iOS 15.0, *)
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
