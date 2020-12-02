//
//  TestViewController.swift
//  WeCanDo
//
//  Created by 서원영 on 2020/11/19.
//

import UIKit


class TestViewController: UIViewController {
    
    lazy var editTF: UITextField = {
        let tf = UITextField()
        return tf
    }()
    lazy var editTFView: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemGroupedBackground
        view.addSubview(editTF)
        editTF.translatesAutoresizingMaskIntoConstraints = false
        editTF.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        editTF.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(editTFView)
        editTFView.translatesAutoresizingMaskIntoConstraints = false
        editTFView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        editTFView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        editTFView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
}
