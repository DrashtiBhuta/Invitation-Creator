//
//  TemplatesCollectionViewController.swift
//  Invitation
//
//  Created by Drashti Bhuta on 12/1/17.
//  Copyright © 2017 New York Life. All rights reserved.
//

import UIKit

private let reuseIdentifier = "TemplateCell"


class TemplatesCollectionViewController: UICollectionViewController {
    var fileList: [String]!
    var templateBundlePath: String!
    var selectedTemplate : UIImage!
    var selectedBundle : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBundle()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupBundle(){
        if let bundlePath = Bundle.main.path(forResource: selectedBundle, ofType: "bundle"){
            templateBundlePath = bundlePath
            if let files = try? FileManager.default.contentsOfDirectory(atPath: templateBundlePath ){
                fileList = files
            }
        }
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
        return fileList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? TemplateCollectionViewCell{
            let name = fileList[indexPath.row]
            if templateBundlePath != nil {
                let bundle: Bundle = Bundle.init(path: templateBundlePath!)! // bundle is there
                if let sticker = UIImage(named: name, in: bundle, compatibleWith: nil){
                    cell.addImage(stickerImage: sticker)
                    
                }
                
            }
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? TemplateCollectionViewCell{
            let name = fileList[indexPath.row]
            if templateBundlePath != nil {
                let bundle: Bundle = Bundle.init(path: templateBundlePath!)! // bundle is there
                if let sticker = UIImage(named: name, in: bundle, compatibleWith: nil){
                    selectedTemplate = sticker
                    performSegue(withIdentifier: "customiseSeque", sender: self)
                }
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "customiseSeque"){
            if let nextVC = segue.destination as? ViewController{
              
               nextVC.backImage = selectedTemplate
                print("ADDED")
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
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
        
            
}
