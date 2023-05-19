//
//  SHNavgationBar.swift
//  KumuWeb_Example
//
//  Created by Ray on 2023/5/19.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

class SHNavgationBar: UINavigationBar {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initCommon() 
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initCommon()
    }
    func initCommon() {
       
        
        if #available(iOS 13.0, *) {
            let appearnce = UINavigationBarAppearance()
            appearnce.configureWithOpaqueBackground()
            appearnce.backgroundColor = UIColor.red
//            appearnce.titleTextAttributes = [<#NSAttributedString#>,<#NSAttributedString#>]
            self.scrollEdgeAppearance = appearnce
            self.standardAppearance = appearnce
        } else {
            // Fallback on earlier versions
        }
    }

}
