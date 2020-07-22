//
//  View+Extension.swift
//  Dating
//
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func setShadow(shadowColor: UIColor) {
        self.layer.masksToBounds = false;
        self.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        self.layer.shadowRadius = 4;
        self.layer.shadowOpacity = 1;
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.cornerRadius = 10
    }
    
    func setShadowandBorderColor(shadowColor: UIColor, cornerRadius: CGFloat) {
        self.layer.masksToBounds = false;
        self.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        self.layer.shadowRadius = 4;
        self.layer.shadowOpacity = 1;
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = cornerRadius
    }

    func addBorderColor(borderColor: UIColor, borderWidth: CGFloat, cornerRadius: CGFloat) {
        self.layer.masksToBounds = false;
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
    }
    
    func addBorderColorWithoutCornerRadius(borderColor: UIColor, borderWidth: CGFloat) {
        self.layer.masksToBounds = false;
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
    }
    
    func addDashedBorder() {
        let color = UIColor.blue.cgColor
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
        self.layer.addSublayer(shapeLayer)
    }
    
    func makeViewCircular(){
        self.layer.cornerRadius = self.frame.size.width/2
        self.layer.masksToBounds = true
    }
    
    func setGradientColor() {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [UIColor.blue.cgColor, UIColor.red.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
        self.layer.insertSublayer(gradient, at: 0)
    }
}

extension UIView {
    class func loadFromNibNamed(nibNamed: String, bundle: Bundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
}
