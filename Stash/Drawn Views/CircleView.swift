//
//  CircleView.swift
//  Stash
//
//  Created by Christopher Martin on 2/5/18.
//  Copyright © 2018 Christopher Martin. All rights reserved.
//

import UIKit

protocol Greenable {
    var isGreen: Bool {get}
}

protocol TextAttachable {
    var overlaidLabel: UILabel {get set}
}

//MARK: - Class
@IBDesignable
class CircleView: UIView, Greenable, TextAttachable{
    
//MARK: - Variables
    private var color: UIColor {
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    internal var overlaidLabel: UILabel = UILabel()
    
    public var text: String?{
        didSet{
            self.overlaidLabel.text = self.text
        }
    }
    
    var isGreen: Bool{
        didSet{
            switch self.isGreen {
            case true:
                self.color = UIColor.green
                
            case false:
                self.color = UIColor.red
            }
        }
    }
    
    
    
//MARK: - Init
    public init(color: UIColor, isGreen: Bool) {
        self.color = color
        self.isGreen = isGreen
        super.init(frame: CGRect.zero)
        
    }
//IS REQUIRED FOR IBDesignables.  
    public override init(frame: CGRect) {
        self.color = UIColor.black
        self.isGreen = true
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.color = UIColor.black
        self.isGreen = true
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        let insetBounds = self.bounds.insetBy(dx: 2.0, dy: 2.0)
        let path = UIBezierPath(ovalIn: insetBounds)
        self.color.setFill()
        path.fill()
    }
    
    override func layoutSubviews() {
        let label = self.overlaidLabel
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        self.centerXAnchor.constraint(equalTo: label.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: label.centerYAnchor).isActive = true
        
    }
}


