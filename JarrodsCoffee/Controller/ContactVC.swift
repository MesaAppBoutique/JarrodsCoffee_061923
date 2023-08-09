//
//  ContactUsViewController.swift
//  JarrodsCoffee
//
//  Created by Michael Bogner on 6/21/21.
//

import UIKit
import MessageUI

class ContactVC: UIViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func onClickPhone(_ sender: UIButton) {
        guard let number = URL(string: "tel://" + "4808227146") else { return }
            UIApplication.shared.open(number)
    }
    
    @IBAction func onClickEmail(_ sender: UIButton) {
        sendEmail()
    }
    // LSApplicationQueriesSchemes must be added to info.plist as an array with all sites
    // to be granted access listed under it
    // Bug-testing applications likely only works on Iphones
    
    @IBAction func onClickFaceBook(_ sender: UIButton) {
        
        let appURL = NSURL(string: "fb://profile/Jarrodsartcoffeeteagallery/")!
        let webURL = NSURL(string: "https://www.facebook.com/Jarrodsartcoffeeteagallery/")!

        let application = UIApplication.shared

        if application.canOpenURL(appURL as URL) {
             application.open(appURL as URL)
        } else {
             application.open(webURL as URL)
        }
    }
    
    
    @IBAction func onClickInstagram(_ sender: UIButton) {
        
        let appURL = NSURL(string: "instagram://user?username=jarrodscoffeetg")!
        let webURL = NSURL(string: "https://www.instagram.com/explore/locations/1015262131/jarrods-coffee-tea-gallery/?hl=en")!

        let application = UIApplication.shared

        if application.canOpenURL(appURL as URL) {
             application.open(appURL as URL)
        } else {
             application.open(webURL as URL)
        }
    }
    
    func sendEmail() {
        let application = UIApplication.shared
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["jarrodmartinez@icloud.com"])
            // mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
            
            present(mail, animated: true)
        } else {
            let alertController = UIAlertController(title: "Email", message: "Phone's Email is not set up", preferredStyle: UIAlertController.Style.alert)
            self.present(alertController, animated: true, completion: nil)
            alertController.view.tintColor = .blue
            let delay = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: delay) {
                let webURL = NSURL(string: "https://jarrodscoffeeteaandgallery.com/contact-us/")!
                    application.open(webURL as URL)  //only these two lines are needed if no need for an alert
              alertController.dismiss(animated: true, completion: nil)
            }
            
        }

    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }

}
