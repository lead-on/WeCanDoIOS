//
//  DetailTableViewController.swift
//  WeCanDo
//
//  Created by 서원영 on 2020/11/18.
//

import UIKit


var reusableIdentifier = "detailcell"


class DetailTableViewController: UITableViewController {
    
    var subItems: [SubItem] = [
        SubItem(id: 1, description: "이것은 하위 목록입니다1."),
        SubItem(id: 2, description: "이것은 하위 목록입니다2."),
        SubItem(id: 3, description: "이것은 하위 목록입니다3."),
        SubItem(id: 4, description: "이것은 하위 목록입니다4."),
        SubItem(id: 5, description: "이것은 하위 목록입니다5."),
        SubItem(id: 6, description: "이것은 하위 목록입니다6."),
        SubItem(id: 7, description: "이것은 하위 목록입니다7."),
        SubItem(id: 8, description: "이것은 하위 목록입니다8."),
        SubItem(id: 9, description: "이것은 하위 목록입니다9. 이것은 하위 목록입니다9. 이것은 하위 목록입니다9. 이것은 하위 목록입니다9.. 이것은 하위 목록입니다9.. 이것은 하위 목록입니다9."),
        SubItem(id: 10, description: "이것은 하위 목록입니다10.이것은 하위 목록입니다10.이것은 하위 목록입니다10.이것은 하위 목록입니"),
        SubItem(id: 11, description: "aannoiasdfnioawefnoaweifoweiafowaeifwoaefhawoefibaweoiboaweifbwoaeifbweoaifbweoaibweoaifbweoifboweafibwoeifbweoifbweoifbweo")
    ]
    
    
    @objc func addSubItemTapped() {
        print("addSubItemTapped")
    }
    
    @objc func completeTapped() {
        navigationItem.rightBarButtonItem = nil
        dismissKeyboard()
        var i = subItems.count - 1
        while i >= 0 {
            subItems[i].isEditMode = false
            subItems[i].isSortMode = false
            if subItems[i].description!.isEmpty {
                subItems.remove(at: i)
            }
            i -= 1
        }
//        for i in 0...subItems.count - 1 {
//            subItems[i].isEditMode = false
//            subItems[i].isSortMode = false
//            if subItems[i].description!.isEmpty {
//                print(i)
//                subItems[i].description = " "
//            }
//        }
        // 모든 셀의 editTV의 text 가져와서 subitem의 desc로 넣어주어야 함.
        tableView.reloadData()
        tableView.isEditing = false
    }
    
    @objc func longPressedCell(_ gesture: UILongPressGestureRecognizer) {
        completeTapped()
        for i in 0...subItems.count - 1 {
            subItems[i].isSortMode = true
        }
        tableView.reloadData()
        
        tableView.isEditing = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: UIBarButtonItem.Style.plain, target: self, action: #selector(completeTapped))
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        adjustColors()
    }
    func adjustColors() {
        if self.traitCollection.userInterfaceStyle == .dark {
            // 다크모드
            navigationController?.navigationBar.tintColor = .white
        } else {
            // 라이트모드
            navigationController?.navigationBar.tintColor = .black
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(DetailTableCell.self, forCellReuseIdentifier: reusableIdentifier)
        
//        tableView.separatorInset.left = 20
        
//        tableView.separatorStyle = .none
//        tableView.separatorColor = .systemRed
        
        let detailTableFooterView = DetailTableFooterView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 54))
        detailTableFooterView.delegate = self
        tableView.tableFooterView = detailTableFooterView
        
        // 순서 변경 가능하도록
//        tableView.isEditing = true
        
//        self.hideKeyboardWhenTappedAround()
        
        adjustColors()
    }
    
}


extension DetailTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier, for: indexPath) as! DetailTableCell
        cell.subItem = self.subItems[indexPath.row]
        cell.selectionStyle = .none // 눌렀을때 이펙트 제거
        cell.delegate = self
        cell.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPressedCell(_:))))
        
        // 이거 해줘야 cell 안의 버튼이 동작함..
        cell.contentView.isUserInteractionEnabled = false
        
        return cell
    }
    
    // for dynamic height (label의 높이가 잡혀있어야 적용됨)
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // remove button 제거 (isEditing 하면 생김)
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        // 순서변경 모드일때는 밀어서 제거 off, 아닐때는 밀어서 제거 on
        if tableView.isEditing {
            return .none
        } else {
            return .delete
        }
    }
    // 삭제
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            subItems.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .left)
            
            completeTapped()
        }
    }
    // 셀의 위치가 바뀌었을때 호출됨
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let subItem = subItems.remove(at: sourceIndexPath.row)
        subItems.insert(subItem, at: destinationIndexPath.row)
    }
    // Delete 버튼 텍스트 변경
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
    }
    
}


extension DetailTableViewController: DetailTableCellProtocol {
    func setEditMode(subItem: SubItem) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: UIBarButtonItem.Style.plain, target: self, action: #selector(completeTapped))
    }
    
    func setFinished(subItem: SubItem, isFinished: Bool) {
        for i in 0...subItems.count - 1 {
            if subItem.id == subItems[i].id {
                subItems[i].isFinished = isFinished
                tableView.reloadData()
                break
            }
        }
        // 완료 버튼 없애주기 (editmode 해제 / reloadData때문에 어차피 해제됨)
        navigationItem.rightBarButtonItem = nil
    }
    
    func editText(subItem: SubItem, text: String) {
        for i in 0...subItems.count - 1 {
            if subItem.id == subItems[i].id {
                subItems[i].description = text
                break
            }
        }
    }
}


extension DetailTableViewController: DetailTableFooterViewProtocol {
    func addSubItem() {
        let subItem = SubItem(id: 99, description: "클릭하면 수정, 더블클릭하면 완료됩니다.")
        subItems.append(subItem)
        tableView.reloadData()
    }
}
