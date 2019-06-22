//
//  CustomControl.swift
//  StarRating
//
//  Created by Corey Sessions on 6/21/19.
//  Copyright © 2019 Corey Sessions. All rights reserved.
//

import Foundation
import UIKit

class CustomControl: UIControl {
    var value: Int = 1
    
    var labelArray = [UILabel]()
    
    private let componentDimension: CGFloat     = 40.0
    private let componentCount                  = 5
    private let componentActiveColor: UIColor   = .black
    private let componentInactiveColor: UIColor = .gray
    
    required init?(coder aCoder: NSCoder) {
        super.init(coder: aCoder)
        
        self.setup()
    }
    
    override var intrinsicContentSize: CGSize {
        let componentsWidth = CGFloat(componentCount) * componentDimension
        let componentsSpacing = CGFloat(componentCount + 1) * 8.0
        let width = componentsWidth + componentsSpacing
        return CGSize(width: width, height: componentDimension)
    }
    
    private func setup() {
        for i in 1...componentCount {
            let space = (componentDimension + 8) * CGFloat(i) - componentDimension
            // CD (40 + 8) spacing * index - CD 40
            let starLbl             = UILabel(frame: CGRect(x: space, y: 0.0, width: componentDimension, height: componentDimension))
            starLbl.text            = ""
            starLbl.tag             = i
            starLbl.textAlignment   = .center
            starLbl.font            = UIFont.boldSystemFont(ofSize: 32)
            starLbl.textColor       = i == 1 ? componentActiveColor : componentInactiveColor
            addSubview(starLbl)
            labelArray.append(starLbl)
        }
    }
    
    private func updateValue(at touch: UITouch) {
        let touchPoint = touch.location(in: self)
        
        for label in self.labelArray {
            if label.frame.contains(touchPoint) {
                if self.value != label.tag {
                    label.performFlare()
                    self.value = label.tag
                    
                    for label in self.labelArray {
                        if label.tag <= value {
                            label.textColor = componentActiveColor
                        } else {
                            label.textColor = componentInactiveColor
                        }
                    }
                    
                    sendActions(for: .valueChanged)
                }
            }
        }
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        updateValue(at: touch)
        return true
    }
    
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let touchPoint = touch.location(in: self) // Grabbing the touch location.
        if bounds.contains(touchPoint) { // Checking to see if the touch is within the bounds.
            sendActions(for: [.touchDragInside, .valueChanged])
            updateValue(at: touch)
        } else {
            sendActions(for: [.touchDragOutside])
        }
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        
        // MARK: - What is going on here?
        defer { super.endTracking(touch, with: event) }
        
        
        guard let touch = touch else { return }
        let touchPoint = touch.location(in: self)
        if bounds.contains(touchPoint) {
            sendActions(for: [.touchUpInside, .valueChanged])
            updateValue(at: touch)
        } else {
            sendActions(for: [.touchUpOutside])
        }
    }
    
    override func cancelTracking(with event: UIEvent?) {
        sendActions(for: .touchCancel)
        
    }
}

extension UIView {
    // "Flare view" animation sequence
    func performFlare() {
        func flare()   { transform = CGAffineTransform(scaleX: 1.6, y: 1.6) }
        func unflare() { transform = .identity }
        
        UIView.animate(withDuration: 0.3,
                       animations: { flare() },
                       completion: { _ in UIView.animate(withDuration: 0.1) { unflare() }})
    }
}
