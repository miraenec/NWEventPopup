//
//  NativeViewDemo.swift
//  TestNWEventPopup_iOS
//
//  Created by Minjun Kim on 2021/07/19.
//

import UIKit

class NativeViewDemo: UIViewController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let eventPopup = NWEventPopup.shared
        eventPopup.initLogger(self)
        
        var params: [String:Any] = [:]
        params["user_id"] = "test01"
        params["v_id"] = "A2008031208415926"
        eventPopup.requestPopup(self, paramMap: params as Dictionary)
    }
    
    @IBAction func clickedClose(_ sedner: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension NativeViewDemo : OnNextWebPopupCallback {
    func OnNextWebPopup(scheme: String) -> Void {
        let alertController = UIAlertController(title: "스키마호출", message: scheme, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in
            
        }))
        self.present(alertController, animated: true, completion: nil)
    }
}
