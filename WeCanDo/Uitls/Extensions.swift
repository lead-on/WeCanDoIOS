//
//  Extensions.swift
//  WeCanDo
//
//  Created by 서원영 on 2020/11/17.
//

import UIKit


extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}


extension UILabel {
    func setLineSpacing(value: CGFloat) {
        let attrString = NSMutableAttributedString(string: text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = value
        attrString.addAttributes([.paragraphStyle : paragraphStyle], range: NSMakeRange(0, attrString.length))
        attributedText = attrString
    }
    
    func getHeight() -> CGFloat {
        return ("1" as NSString).size(withAttributes: [NSAttributedString.Key.font : font!]).height
    }
}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        // onClick 이벤트 추가하기
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        // 이거 해주면 버튼같은 component 눌러도 실행됨
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        // 키보드 숨기는거
        view.endEditing(true)
    }
    
    // 키보드가 보여지고 숨겨질때 발생하는 이벤트 감지
    func moveViewWithKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        // 키보드가 보여질때 뷰를 전반적으로 키보드 높이만큼 올림
        // 키보드 사이즈 받아오기
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            // view.frame.origin: view의 꼭지점
            if self.view.frame.origin.y == 0 {
                // 뷰의 최상단 꼭지점을 키보드의 높이만큼 빼줌
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        // 올라가있는 뷰 원복
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
