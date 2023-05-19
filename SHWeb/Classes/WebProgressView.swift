//
//  WebProgressView.swift
//  KumuWeb_Example
//
//  Created by Ray on 2023/5/19.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

class WebProgressView: UIView {
    lazy var progressBarView: UIView = UIView.init()
    var barWidthLayout: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initCommon()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initCommon()
    }
    
    
    func initCommon() {
        self.backgroundColor = .white;
        self.addSubview(progressBarView)
        progressBarView.backgroundColor = .red
        progressBarView.translatesAutoresizingMaskIntoConstraints = false
        let barWidth = NSLayoutConstraint.init(item: progressBarView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.width, multiplier: 0, constant: 0)
        self.addConstraints([
            NSLayoutConstraint.init(item: progressBarView, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: progressBarView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: progressBarView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0),
            barWidth
        ])
        self.barWidthLayout = barWidth
    }
    
    func updateProgress(progress: CGFloat, isAnimation: Bool = true) {
        var progressNew = progress
        if progressNew > 1 {
            progressNew = 1
        }
        if progressNew < 0 {
            progressNew = 0
        }
        if let old = self.barWidthLayout {
            self.removeConstraint(old)
        }
        do{
            let barWidth = NSLayoutConstraint.init(item: progressBarView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.width, multiplier: progressNew, constant: 0)
            self.addConstraint(barWidth)
            self.barWidthLayout = barWidth
        }
        self.isHidden = false
        if isAnimation {
            UIView.animate(withDuration: TimeInterval(0.25)) {
                self.layoutIfNeeded()
            } completion: { flag in
                if progressNew == 1 {
                    self.isHidden = true
                    self.updateProgress(progress: 0, isAnimation: false)
                }
            }
        } else {
            self.layoutIfNeeded()
        }
        
        
        
    }
    
}
