//
//  StickersCollectionViewController.swift
//  Invitation
//
//  Created by Drashti Bhuta on 11/20/17.
//  Copyright © 2017 New York Life. All rights reserved.
//

import UIKit

private let reuseIdentifier = "stickerCell"


class StickersCollectionViewController: UICollectionViewController {
    var fileList: [String]!
    var stickerBundlePath : String!
    var header : HeaderCollectionReusableView!
    weak var controller : ViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
       // self.collectionView!.register(StickerCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
         self.preferredContentSize = CGSize(width: 320, height: 450)
        setupBundle()
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return getImageCount()
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "stickerCell", for: indexPath) as? StickerCollectionViewCell{
            let name = fileList[indexPath.row]
            if stickerBundlePath != nil {
                let bundle: Bundle = Bundle.init(path: stickerBundlePath!)! // bundle is there
                if let sticker = UIImage(named: name, in: bundle, compatibleWith: nil){
                    cell.addImage(stickerImage: sticker)
                }
                
            }
                
            
                
            return cell
        }
        
        return UICollectionViewCell()
        // Configure the cell
    
    }
    
    func getImageCount() -> Int{
        return self.fileList.count
    }
    func setupBundle(){
        if let bundlePath = Bundle.main.path(forResource: "stickers", ofType: "bundle"){
            stickerBundlePath = bundlePath
            if let files = try? FileManager.default.contentsOfDirectory(atPath: stickerBundlePath ){
                fileList = files
            }
        }
    }
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }*/

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? StickerCollectionViewCell{
            let name = fileList[indexPath.row]
            if stickerBundlePath != nil {
                let bundle: Bundle = Bundle.init(path: stickerBundlePath!)! // bundle is there
                if let sticker = UIImage(named: name, in: bundle, compatibleWith: nil){
                controller.addSticker(sticker: sticker)
            }
            }
        }
    
    
    }
    func closeTheController(){
        self.dismiss(animated: true, completion: nil)
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerView", for: indexPath as IndexPath) as! HeaderCollectionReusableView
        headerView.controllerCollection = self.self
        return headerView
    }
    
    

}
