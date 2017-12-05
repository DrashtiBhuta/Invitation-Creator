//
//  TemplateCollectionViewCell.swift
//  Invitation
//
//  Created by Drashti Bhuta on 12/1/17.
//  Copyright © 2017 New York Life. All rights reserved.
//

import UIKit

class TemplateCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var templateImageView: UIImageView!
    
    func addImage(stickerImage:UIImage){
        self.templateImageView.image = stickerImage
    }
    
}
