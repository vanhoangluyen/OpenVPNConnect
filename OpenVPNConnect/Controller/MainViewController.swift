//
//  MainViewController.swift
//  VPN
//
//  Created by Hoang Luyen on 4/2/18.
//  Copyright © 2018 BigZero. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var slideView: UIView!
    @IBOutlet weak var coverButton: UIButton!
    @IBOutlet weak var leadingContraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    
    var isSlideMenuOpen: Bool = false {
        didSet {
            if isSlideMenuOpen {
                coverButton.isHidden = false
                slideView.isHidden = false
                createShadowOfSlideView()
            }
            leadingContraint.constant = isSlideMenuOpen ? 0 : -slideView.frame.width
            coverButton.isEnabled = isSlideMenuOpen ? true : false
            containerView.alpha = isSlideMenuOpen ? 0.3 : 1
            UIView.animate(withDuration: 0.35, animations: {[unowned self] in
                self.view.layoutIfNeeded() }) { (isSuccess) in
                    if !self.isSlideMenuOpen {
                        self.slideView.isHidden = true
                        self.createShadowOfSlideView()
                        self.coverButton.isHidden = true
                    }
            }
        }
    }
    
    //MARK: -Create shadow
    func createShadowOfSlideView() {
        self.slideView.layer.shadowColor = UIColor(red: 30/255, green: 60/255, blue: 255/255, alpha: 1).cgColor
//        slideView.layer.shadowColor = UIColor.black.cgColor
        slideView.layer.shadowOffset = CGSize(width: 5, height: 0)
        slideView.layer.shadowOpacity = isSlideMenuOpen ? 1 : 0
        slideView.layer.shadowRadius = isSlideMenuOpen ? 10 : 0
    }
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        isSlideMenuOpen = false
        handlerResultNotification()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handlerResultNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(closeSlideMenu), name: .closeSlideMenu, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @IBAction func closeSlideMenu(_ sender: UIButton) {
        isSlideMenuOpen = !isSlideMenuOpen
    }

}
