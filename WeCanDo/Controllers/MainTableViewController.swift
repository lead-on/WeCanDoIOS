//
//  MainViewController.swift
//  WeCanDo
//
//  Created by 서원영 on 2020/11/16.
//

import UIKit


private let reusableIdentifier = "cell"
private let reusableFooterIdentifier = "footercell"


class MainTableViewController: UITableViewController {
    
    var items: [Item] = [
        Item(title: "목록1 awjefinaweionweoaif noweafnfwnieo naewofinwef", count: 10),
        Item(title: "목록2", count: 4),
        Item(title: "목록3", count: 2),
        Item(title: "목록4", count: 1),
        Item(title: "목록5", count: 6),
        Item(title: "목록6", count: 5),
        Item(title: "목록7", count: 14)
    ]
    
    lazy var addItemButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle(" 목록추가", for: UIControl.State.normal)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.setImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 12)), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(addItem), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    @objc func addItem() {
        print("addItem")
    }
    
    @objc func editItemMode() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: UIBarButtonItem.Style.plain, target: self, action: #selector(finishEditMode))
        adjustColors()
        
        for i in 0...items.count - 1 {
            items[i].editMode = true
        }
        tableView.reloadData()
    }
    
    @objc func finishEditMode() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "편집", style: UIBarButtonItem.Style.plain, target: self, action: #selector(editItemMode))
        adjustColors()
        
        for i in 0...items.count - 1 {
            items[i].editMode = false
        }
        tableView.reloadData()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        adjustColors()
    }
    func adjustColors() {
        if self.traitCollection.userInterfaceStyle == .dark {
            // 다크모드
            navigationItem.rightBarButtonItem?.tintColor = .white
            addItemButton.tintColor = .white
        } else {
            // 라이트모드
            navigationItem.rightBarButtonItem?.tintColor = .black
            addItemButton.tintColor = .black
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .tertiarySystemGroupedBackground
        
        finishEditMode()
        
        tableView.register(MainTableCell.self, forCellReuseIdentifier: reusableIdentifier)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 24))
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 54))
        footerView.addSubview(addItemButton)
        addItemButton.translatesAutoresizingMaskIntoConstraints = false
        addItemButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
        addItemButton.rightAnchor.constraint(equalTo: footerView.rightAnchor, constant: -16).isActive = true
        
        tableView.tableFooterView = footerView
        
        adjustColors()
    }
    
}


extension MainTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    // 셀에 아이템 전달
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier, for: indexPath) as! MainTableCell
        
        // 셀 눌렸을때 스타일
        cell.selectionStyle = .none
        
        cell.delegate = self
        
        cell.item = self.items[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
}


extension MainTableViewController: MainTableCellProtocol {
    func detailItem() {
        print("detailItem")
    }
    
    func removeItem() {
        print("removeItem")
    }
}
