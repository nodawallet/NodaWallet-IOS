
//  n 15/02/20.
//  .
//

import Foundation
import UIKit

extension UIButton {
    
    func addBorderAndColor(width: CGFloat, color: CGColor, cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderColor = color
        self.layer.borderWidth = width
        self.clipsToBounds = true
    }
    
}
