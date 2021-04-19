//
//  TestController.swift
//  lab-swift
//
//  Created by huangqing on 2021/1/7.
//  Copyright © 2021 qeeniao35. All rights reserved.
//

import UIKit

class TestController: GenericController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _initialComponentsUI()
    }
    
    // MARK: - Data
    private func _initialComponentsDatas() {}
    
    
    // MARK: - UI
    private func _initialComponentsUI() {
        
        view.backgroundColor = .white
        
        labNavBar.navbarTitle = "非首页"
        
        let textField = UITextField(frame: CGRect(x: 20, y: 100, width: view.frame.width - 20 * 2, height: 40))
        textField.backgroundColor = .gray
        textField.tintColor = .red
        textField.font = UIFont.systemFont(ofSize: 10)
        view.addSubview(textField)
        textField.becomeFirstResponder()
        
        NotificationCenter.default.addObserver(self, selector: #selector(editHandler), name: UITextField.textDidChangeNotification, object: textField)
    }
    
    
    // MARK: - Logic
    
    @objc func editHandler(notification: Notification) {
        guard let textfield = notification.object as? UITextField,
              let text = textfield.text, text.count > 0
        else {
            debugPrint("文字为空")
            return
        }
        
        // 没有高亮的时候才开始算长度
        guard let selectRange = textfield.markedTextRange,
              let _ = textfield.position(from: selectRange.start, offset: 0)
        else {
            var character_length = 0
            for index in 0..<text.count {
                let uc = (text as NSString).character(at: index)
                let char_length = isascii(Int32(uc))
                debugPrint("字符串长度:\(char_length)")
                if char_length != 0 {
                    character_length += 1
                }else {
                    character_length += 2
                }
            }
            
            debugPrint("总长度是:\(character_length)")
            return
        }
        
        debugPrint("文字高亮不计算长度")
    }
    
    // MARK: - Delegate
    
    lazy var titleLabel: UILabel = {
        let newLabel = UILabel()
        
        return newLabel
    }()
}
