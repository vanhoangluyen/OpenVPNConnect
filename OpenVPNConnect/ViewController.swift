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
        configure()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func configure() {
        if let filepath = Bundle.main.url(forResource: "client", withExtension: "ovpn") {
            do {
                let contents = try String(contentsOf: filepath)
                if let st = Regex.pregMatchFirst(contents, regex: "1(.*?)\n") {
                    let smth = st.replacingOccurrences(of: "\n", with: "")
                    if let index = (smth.range(of: " ")?.upperBound) {
                        let port = String(smth.suffix(from: index))
                        print(port)
                    }
                    if let index = (smth.range(of: " ")?.lowerBound) {
                        let ip = String(smth.prefix(upTo: index))
                        print(ip)
                    }
                }
                
                let st4 = try Regex.decodeContents(for: contents)
                
                if let privateKey = Regex.pregMatchFirst(st4, regex: "-----BEGINPRIVATEKEY-----(.*?)-----ENDPRIVATEKEY-----") {
                    print(privateKey)
                }
                
                if let st = Regex.pregMatchFirst(st4, regex: "Modulus:(.*?)Exponent") {
                    let publicKey = st.replacingOccurrences(of: "Modulus:", with: "").replacingOccurrences(of: "Exponent", with: "")
                    print(publicKey)
                }
            } catch {
                // contents could not be loaded (.+?)([123]*)(.*)
            }
        }
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

