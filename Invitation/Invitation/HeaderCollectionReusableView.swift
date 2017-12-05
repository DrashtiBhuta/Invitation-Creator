//
//  HeaderCollectionReusableView.swift
//  Invitation
//
//  Created by Drashti Bhuta on 11/21/17.
//  Copyright © 2017 New York Life. All rights reserved.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    weak var controllerCollection : StickersCollectionViewController!
    
    @IBAction func closePopUp(_ sender: Any) {
        controllerCollection.closeTheController()
    }
    
}
