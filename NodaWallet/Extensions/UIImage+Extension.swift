//
//  UIImage+Extension.swift
//  NodaWallet
//
//  Created by macOsx on 20/04/20.
//  .
//

import Foundation
import UIKit

extension UIImageView {
    
    func loadImage(string: String) {
        if string.contains(".") {
            self.sd_setImage(with: URL(string: string), completed: nil)
        } else {
            self.image = UIImage(named: string)
        }
    }
    
    func updateTintColor() {
        self.image = self.image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = Constants.AppColors.App_Orange_Color
    }
    
}

extension UIImage {
    func toString() -> String? {
        let data: Data? = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
}
