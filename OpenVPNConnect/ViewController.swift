//
//  ViewController.swift
//  OpenVPNConnect
//
//  Created by apple on 5/6/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import OpenVPNAdapter

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func connectToOpenVPNServer( _ sender : UIButton) {
        if OpenVPNManager.shared.isDisconnected {

            OpenVPNManager.shared.connectWithCertificate { error in
                let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            }
        } else {
            showAlert(vc: self, title: "Are You DisConnect", message: "")
        }
//        if OpenVPNManagerConnect.shared.isDisconnected {
//            OpenVPNManagerConnect.shared.startOpenVPNTunnel()
//        } else {
//            OpenVPNManagerConnect.shared.stopOpenVPNTunnel()
//        }
    }
    func showAlert(vc: UIViewController, title:String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "DisConnect", style: .default) { (result : UIAlertAction) -> Void in
            OpenVPNManager.shared.stopOpenVPNTunnel()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { Void in}
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        vc.present(alertController, animated: true, completion: nil)
    }
}

