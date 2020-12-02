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
        Item(title: "목록1목록목록목록목록목록목록목록목록목록목록목록목록목록목록목록목록", hexCode: "#000000", count: 10),
        Item(title: "목록2", hexCode: "#ED1D24", count: 4),
        Item(title: "목록3", hexCode: "#1DB54A", count: 2),
        Item(title: "목록4", hexCode: "#FBB03C", count: 1),
        Item(title: "목록5", hexCode: "#808080", count: 6)
//        Item(title: "목록6", hexCode: "#754B23", count: 5),
//        Item(title: "목록7", hexCode: "#C59C6D", count: 14),
//        Item(title: "목록8", hexCode: "#C59C6D", count: 14),
//        Item(title: "목록9", hexCode: "#C59C6D", count: 14),
//        Item(title: "목록10", hexCode: "#C59C6D", count: 14),
//        Item(title: "목록11", hexCode: "#C59C6D", count: 14),
//        Item(title: "목록12", hexCode: "#C59C6D", count: 14),
//        Item(title: "목록13", hexCode: "#C59C6D", count: 14),
//        Item(title: "목록14", hexCode: "#C59C6D", count: 14),
//        Item(title: "목록15", hexCode: "#C59C6D", count: 14),
//        Item(title: "목록16", hexCode: "#C59C6D", count: 14),
//        Item(title: "목록17", hexCode: "#C59C6D", count: 14),
//        Item(title: "목록18", hexCode: "#C59C6D", count: 14),
//        Item(title: "목록19", hexCode: "#C59C6D", count: 14)
    ]
    
    @objc func editItemMode() {
        if items.count == 0 { return }
//        if items.count == 0 {
//            items.append(Item(title: "new", hexCode: "#000000", count: 0))
//            collectionView.reloadData()
//            return
//        }
        
        isEditMode = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: UIBarButtonItem.Style.plain, target: self, action: #selector(finishEditMode))
        adjustColors()
        
        if items.count > 0 {
            for i in 0...items.count - 1 { items[i].isEditMode = true }
            collectionView.reloadData()
        }
    }
    
    @objc func finishEditMode() {
        isEditMode = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "편집", style: UIBarButtonItem.Style.plain, target: self, action: #selector(editItemMode))
        adjustColors()
        
        if items.count > 0 {
            for i in 0...items.count - 1 { items[i].isEditMode = false }
            collectionView.reloadData()
        }
    }
    
    @objc func longPressedCell(_ gesture: UILongPressGestureRecognizer) {
        if !isEditMode { return }
        
        guard let collectionView = collectionView else { return }
        
        switch gesture.state {
        case .began:
            guard let targetIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else { return }
            let cell = collectionView.cellForItem(at: targetIndexPath) as! MainCollectionCell
            cell.isDragMode = true
            collectionView.beginInteractiveMovementForItem(at: targetIndexPath)
            
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: collectionView))
            
        case .ended:
            collectionView.endInteractiveMovement()
            // 드래그 완료하면 모든 셀 isDragMode false로 변경
            // **주의) 현재 눈에 보이는 cell만 가져온다...
            // 어차피 dragmode는 현재 눈에 보이니 여기서는 써도 상관없음
            for visibleCell in collectionView.visibleCells {
                let cell = visibleCell as! MainCollectionCell
                cell.isDragMode = false
            }
            
        default:
            collectionView.cancelInteractiveMovement()
        }
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
        
        collectionView.backgroundColor = .tertiarySystemGroupedBackground
        collectionView.register(MainCollectionCell.self, forCellWithReuseIdentifier: reusableIdentifier)
        collectionView.register(MainCollectionFooterCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: reusableFooterIdentifier)
        
        adjustColors()
    }
    
}


extension MainCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // item 개수 0이면 nodataview (커스텀 뷰)
        if items.count == 0 {
            let mainCollectionNoDataView = MainCollectionNoDataView()
            mainCollectionNoDataView.delegate = self
            self.collectionView.backgroundView = mainCollectionNoDataView
        } else {
            self.collectionView.backgroundView = nil
        }
        
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableIdentifier, for: indexPath) as! MainCollectionCell
        cell.item = self.items[indexPath.row]
        // 수정할때 어떤 아이템을 수정하는지 알아야하기때문에 index 세팅해둠
        // 이곳에서 해주는 이유는 drag 끝난 시점에 indexPath를 자동으로 알아서 세팅해주기때문
        cell.indexPath = indexPath
        cell.isDragMode = false // 무조건 false
        cell.delegate = self
        
        // **중요 직접 recognizer 달아주기 (began, changed, ended 받아오기 위함!)
        cell.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPressedCell(_:))))
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reusableFooterIdentifier, for: indexPath) as! MainCollectionFooterCell
        cell.delegate = self
        return cell
    }
    
    // 드래깅을 허용하거나 막을 수 있음 (isEditMode로 드래깅 여부 판별)
    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return isEditMode
    }
    // 셀의 위치가 바뀌었을때 호출됨
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // 배열 위치 바꿔주기
        let item = items.remove(at: sourceIndexPath.row)
        items.insert(item, at: destinationIndexPath.row)
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
        
        // 편집모드일때 footer 사라지게
        if isEditMode {
            return CGSize.zero
        } else {
            return CGSize(width: view.frame.width, height: 24)
        }
    }
}


extension MainCollectionViewController: MainCollectionCellProtocol {
    // 삭제 함수
    func removeItem(indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        collectionView.reloadData()
        
        // 아이템들 다 사라지면 편집모드 해제
//        isEditMode = false
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "편집", style: UIBarButtonItem.Style.plain, target: self, action: #selector(editItemMode))
    }
    
    // 수정 함수
    func startEditItemViewController(item: Item, indexPath: IndexPath) {
        let editItemViewController = EditItemViewController()
        editItemViewController.mode = "MODIFY"
        editItemViewController.item = item
        editItemViewController.indexPath = indexPath
        editItemViewController.delegate = self
        navigationItem.backButtonTitle = "취소"
        navigationController?.pushViewController(editItemViewController, animated: true)
    }
    
    // 자세히보기
    func startDetailTableViewController() {
        navigationItem.backButtonTitle = "목록"
        navigationController?.pushViewController(DetailTableViewController(), animated: true)
    }
}


extension MainCollectionViewController: MainCollectionFooterCellProtocol, MainCollectionNoDataViewProtocol {
    // 목록 새로 추가
    func startEditItemViewController() {
        let editItemViewController = EditItemViewController()
        editItemViewController.mode = "CREATE"
        editItemViewController.delegate = self
        navigationItem.backButtonTitle = "취소"
        navigationController?.pushViewController(editItemViewController, animated: true)
    }
}


extension MainCollectionViewController: EditItemViewControllerProtocol {
    // 목록 추가/수정 뷰에서 리턴하는 함수
    func returnItem(mode: String, item: Item, indexPath: IndexPath?) {
        if mode == "CREATE" {
            var _item = item
            // nodata 목록추가가 보통 편집모드에서 발생하기 때문에 자연스러움 위하여 현재
            // editmode 받아서 뷰생성
            _item.isEditMode = self.isEditMode
            items.append(_item)
        } else {
            guard let _indexPath = indexPath else { return }
            items[_indexPath.row].title = item.title
            items[_indexPath.row].hexCode = item.hexCode
        }
        collectionView.reloadData()
    }
}
