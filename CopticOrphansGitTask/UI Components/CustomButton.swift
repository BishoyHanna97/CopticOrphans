//
//  CustomButton.swift
//  CopticOrphansGitTask
//
//  Created by Bishoy Hanna on 04/04/2025.
//

import UIKit

class CustomButton: UIButton {
    init(title: String, backgroundColor: UIColor) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = 8
        self.setTitleColor(.white, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
