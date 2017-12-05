//
//  HomePageViewController.swift
//  Invitation
//
//  Created by Drashti Bhuta on 12/3/17.
//  Copyright © 2017 New York Life. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var btnBabyShower: UIButton!
    @IBOutlet weak var btnBirthay: UIButton!
    @IBOutlet weak var btnHouseWarming: UIButton!
    @IBOutlet weak var letterView: UIView!
    @IBOutlet weak var btnWedding: UIButton!
    @IBOutlet weak var envelopeOpenView: UIImageView!
    @IBOutlet weak var envelopeTopView: UIImageView!
    var bundle : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.sendSubview(toBack: envelopeBaseView)
        //view.sendSubview(toBack: letterView)
        // Do any additional setup after loading the view.
    }

    @IBAction func showTemplates(_ sender: Any) {
        let button = sender as! UIButton
        
        if button == btnBirthay{
            bundle = "BirthdayTemplate"
        }
        if button == btnWedding{
            bundle = "BirthdayTemplate"
        }
        if button == btnBabyShower{
            bundle = "BirthdayTemplate"
        }
        if button == btnHouseWarming{
            bundle = "BirthdayTemplate"
        }
        performSegue(withIdentifier: "templateSeque", sender: self)
    }
    @IBOutlet weak var envelopeBaseView: UIImageView!
    @IBAction func openEnvelope(_ sender: Any) {
        
        envelopeTopView.isHidden = true
        envelopeOpenView.isHidden = false
        letterView.isHidden = false
        containerView.bringSubview(toFront: letterView)
        //view.bringSubview(toFront: envelopeBaseView)
        UIView.transition(from: envelopeTopView, to: envelopeTopView, duration: 0.6, options: .transitionFlipFromBottom, completion: nil)
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "templateSeque"){
            if let nextVC = segue.destination as? TemplatesCollectionViewController{
                
                nextVC.selectedBundle = bundle
                
                //print("ADDED")
            }
        
    }
    }
 

}
