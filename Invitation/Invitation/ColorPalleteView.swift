//
//  ColorPalleteView.swift
//  Invitation
//
//  Created by Drashti Bhuta on 11/19/17.
//  Copyright © 2017 New York Life. All rights reserved.
//

import UIKit

class ColorPalleteView: UIView {
    
    @IBOutlet weak var btnTangerine: UIButton!
    @IBOutlet weak var btnGrape: UIButton!
    @IBOutlet weak var btnMagenta: UIButton!
    @IBOutlet weak var btnBlack: UIButton!
    @IBOutlet weak var btnClover: UIButton!
    @IBOutlet weak var btnWhite: UIButton!
    @IBOutlet weak var btnLemon: UIButton!
    @IBOutlet weak var btnRed: UIButton!
    @IBOutlet weak var btnBrown: UIButton!
    @IBOutlet weak var btnBlue: UIButton!
    weak var controller : ViewController!
    
    var fontColor : UIColor!
     // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        setUpButton(button:btnRed)
        setUpButton(button:btnGrape)
        setUpButton(button: btnBlue)
        setUpButton(button: btnBlack)
        setUpButton(button: btnBrown)
        setUpButton(button: btnLemon)
        setUpButton(button: btnWhite)
        setUpButton(button: btnClover)
        setUpButton(button: btnMagenta)
        setUpButton(button: btnTangerine)
    }
    
    func setUpButton(button: UIButton){
        button.layer.cornerRadius = 2
        button.layer.borderColor =  UIColor.black.cgColor
        button.layer.borderWidth = 2
    }

    @IBAction func colorSelected(_ sender: Any) {
        let button = sender as! UIButton
        
        switch button {
        case btnTangerine:
            fontColor = UIColor(red: 255/255, green: 153/255, blue: 0/255, alpha: 1)
        case btnMagenta:
            fontColor = UIColor(red: 255/255, green: 0/255, blue: 255/255, alpha: 1)
        case btnClover:
            fontColor = UIColor(red: 0/255, green: 128/255, blue: 0/255, alpha: 1)
        case btnWhite:
            fontColor = UIColor.white
        case btnLemon:
            fontColor = UIColor(red: 255/255, green: 255/255, blue: 102/255, alpha: 1)
        case btnBrown:
            fontColor = UIColor(red: 128/255, green: 64/255, blue: 0/255, alpha: 1)
        case btnBlack:
            fontColor = UIColor.black
        case btnBlue:
           fontColor = UIColor(red: 102/255, green: 204/255, blue: 255/255, alpha: 1)
        case btnGrape:
            fontColor = UIColor(red: 128/255, green: 0/255, blue: 255/255, alpha: 1)
        case btnRed:
            fontColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
        default:
            fontColor = UIColor.black
        }
        controller.txtMessage.textColor = fontColor
        
    }
}
