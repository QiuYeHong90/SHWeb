//
//  WebViewController.swift
//  SHWeb_Example
//
//  Created by Ray on 2023/5/19.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import SHWeb
import UIKit
import WebKit

class WebViewController: SHWebViewController {
    override func msgHander(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
