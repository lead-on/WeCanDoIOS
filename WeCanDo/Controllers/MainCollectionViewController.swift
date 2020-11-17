//
//  MainCollectionViewController.swift
//  WeCanDo
//
//  Created by 서원영 on 2020/11/17.
//

import UIKit


class MainCollectionViewController: UICollectionViewController {
    
    var reusableIdentifier = "itemcell"
    var reusableFooterIdentifier = "itemfootercell"
    
    var isEditMode: Bool = false
    
    var items: [Item] = [
        Item(title: "목록1목록목록목록목록목록목록목록목록목록목록목록목록목록목록목록목록", count: 10),
        Item(title: "목록2", count: 4),
        Item(title: "목록3", count: 2),
        Item(title: "목록4", count: 1),
        Item(title: "목록5", count: 6),
        Item(title: "목록6", count: 5),
        Item(title: "목록7", count: 14)
    ]
    
    @objc func editItemMode() {
        isEditMode = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: UIBarButtonItem.Style.plain, target: self, action: #selector(finishEditMode))
        adjustColors()
        
        for i in 0...items.count - 1 {
            items[i].editMode = true
        }
        collectionView.reloadData()
    }
    
    @objc func finishEditMode() {
        isEditMode = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "편집", style: UIBarButtonItem.Style.plain, target: self, action: #selector(editItemMode))
        adjustColors()
        
        for i in 0...items.count - 1 {
            items[i].editMode = false
        }
        collectionView.reloadData()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        adjustColors()
    }
    func adjustColors() {
        if self.traitCollection.userInterfaceStyle == .dark {
            // 다크모드
            navigationItem.rightBarButtonItem?.tintColor = .white
            navigationController?.navigationBar.tintColor = .white
        } else {
            // 라이트모드
            navigationItem.rightBarButtonItem?.tintColor = .black
            navigationController?.navigationBar.tintColor = .black
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "편집", style: UIBarButtonItem.Style.plain, target: self, action: #selector(editItemMode))
        navigationItem.backButtonTitle = "취소"
        
        collectionView.backgroundColor = .tertiarySystemGroupedBackground
        collectionView.register(MainCollectionCell.self, forCellWithReuseIdentifier: reusableIdentifier)
        collectionView.register(MainCollectionFooterCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: reusableFooterIdentifier)
        
        adjustColors()
    }
    
}


extension MainCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableIdentifier, for: indexPath) as! MainCollectionCell
        cell.item = self.items[indexPath.row]
//        cell.index = indexPath.row
//        cell.backgroundColor = .white
//        cell.layer.cornerRadius = 12
        cell.delegate = self
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
//        if kind == UICollectionView.elementKindSectionHeader {
//            // Header
//        } else {
//            // Footer
//        }
        
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reusableFooterIdentifier, for: indexPath) as! MainCollectionFooterCell
        cell.delegate = self
        return cell
    }
}


extension MainCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 30, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 30, left: 0, bottom: 30, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if isEditMode {
            return CGSize.zero
        } else {
            return CGSize(width: view.frame.width, height: 30)
        }
        
    }
}


extension MainCollectionViewController: MainCollectionCellProtocol {
    func removeItem() {
        print("removeItem")
    }
    
    func startEditItemViewController() {
        print("startEditItemViewController")
    }
}


extension MainCollectionViewController: MainCollectionFooterCellProtocol {
    func startCreateItemViewController() {
        navigationController?.pushViewController(CreateItemViewController(), animated: true)
    }
}
