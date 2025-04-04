//
//  CustomTextField.swift
//  CopticOrphansGitTask
//
//  Created by Bishoy Hanna on 04/04/2025.
//

import UIKit

class CustomTextField: UITextField {
    
    init(placeholder: String, icon: String, isSecure: Bool = false) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.borderStyle = .roundedRect
        self.isSecureTextEntry = isSecure
        self.textContentType = .emailAddress
        
        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = .gray
        leftView = iconView
        leftViewMode = .always
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
