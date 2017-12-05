//
//  StickerCollectionViewCell.swift
//  Invitation
//
//  Created by Drashti Bhuta on 11/20/17.
//  Copyright © 2017 New York Life. All rights reserved.
//

import UIKit

class StickerCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var stickerImgView: UIImageView!
   
    func addImage(stickerImage:UIImage){
        self.stickerImgView.image = stickerImage
    }
    
    
}
