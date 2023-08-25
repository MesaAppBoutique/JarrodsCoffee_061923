//
//  EventsViewController.swift
//  JarrodsCoffee
//
//  Created by Mike Bogner on 6/19/23.
//

import UIKit

class EventsVC: UIViewController {

    @IBAction func closeAction(_ sender: Any) {
        print("close")
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Enable nav bar
        self.navigationController?.isNavigationBarHidden = false
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickPhone(_ sender: Any) {
        guard let number = URL(string: "tel://" + "4808227146") else { return }
            UIApplication.shared.open(number)
    }
    
    

}
