//
//  ViewController.swift
//  Invitation
//
//  Created by Drashti Bhuta on 11/15/17.
//  Copyright © 2017 New York Life. All rights reserved.
//

import UIKit



class ViewController: UIViewController,UIPopoverPresentationControllerDelegate {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var txtMessage: UITextView!
    @IBOutlet weak var templateView: UIView!
    @IBOutlet weak var textControlsView: UIView!
    @IBOutlet weak var controlsView: UIView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var templateViewHeight: NSLayoutConstraint!
    @IBOutlet weak var parentBottomContraint: NSLayoutConstraint!
    var backImage: UIImage!
    var caller = ""
    var sizePicker : UIPickerView!
    var  myUIPicker : UIPickerView!
    var myView: ColorPalleteView!
    var stickerCollection : StickersCollectionViewController!
    var pickerData = ["Arial-BoldMT" , "ChalkboardSE-Regular" , "Chalkduster" , "Noteworthy-Light"]
    var textSizeData = Array(1...40)
    var fontStyleRow = -1
    var fontStyle = ""
    var fontSizeRow = -1
    var textSize  = 15
    var message = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        txtMessage.delegate = self
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(userDragged))
        txtMessage.addGestureRecognizer(gesture)
        txtMessage.isUserInteractionEnabled = true
        backgroundImageView.image = backImage

        //addText()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "popUPSegue" {
            if let vc = segue.destination as? StickersCollectionViewController{
                vc.controller = self
                let pvc = vc.popoverPresentationController
                pvc?.delegate = self
                pvc?.sourceView = self.view
                pvc?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            
                pvc?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
                return
        }
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    @IBAction func textEditor(_ sender: Any) {
        configureTextEditiorControls(sender:sender)
        let button = sender as! UIButton
        if button.tag == 1{
            caller = "FontColor"
           AddTextColor()
        }
        if button.tag == 2{
            caller = "FontStlye"
            addFontStyle()
        }
        if button.tag == 3{
            caller = "FontSize"
            addTextSize()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func saveImage(_ sender: Any) {
        let image = UIImage.imageWithView(view:templateView)
        createDirectory()
        saveImageDocumentDirectory(image: image)
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        
        //getImage()
    }
    func addText(){
        let txtMsg = UITextView()
        let textView1: LDStickerView = LDStickerView(frame: CGRect(x:80, y:80, width:30, height:30))
        textView1.setContentView(contentView: txtMsg)
        textView1.frame = CGRect(x: 80, y: 80, width: 50, height: 50)
        textView1.backgroundColor = UIColor.black
        templateView.addSubview(textView1)
        
    }
   
    func addSticker(sticker : UIImage){
        let imageView1: UIImageView = UIImageView(image:sticker)
        imageView1.contentMode = UIViewContentMode.scaleAspectFit
        let stickerView1: LDStickerView = LDStickerView(frame: CGRect(x:80, y:200, width:(imageView1.frame.size.width ), height:(imageView1.frame.size.height)))
        stickerView1.setContentView(contentView: imageView1)
        stickerView1.frame = CGRect(x: 80, y: 200, width: 50, height: 50)
        templateView.addSubview(stickerView1)
    }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    func saveImageDocumentDirectory(image:UIImage){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("customDirectory/sample.png")
        print(paths)
        if let imageData = UIImagePNGRepresentation(image){
            fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
            print("saved")
        }
        
    }
    func createDirectory(){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("customDirectory")
        if !fileManager.fileExists(atPath: paths){
            try! fileManager.createDirectory(atPath: paths, withIntermediateDirectories: true, attributes: nil)
        }else{
            print("Already dictionary created.")
        }
    }
    func getImage(){
        let fileManager = FileManager.default
        let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent("customDirectory/sample.png")
        if fileManager.fileExists(atPath: imagePAth){
            self.imageView.image = UIImage(contentsOfFile: imagePAth)
        }else{
            print("No Image")
        }
    }
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    @objc  func doneClick() {
        if caller == "FontStlye"{
            fontStyle = pickerData[fontStyleRow]
            myUIPicker.removeFromSuperview()
        }
        if caller == "FontColor"{
            myView.removeFromSuperview()
        }
        if caller == "FontSize"{
            textSize = textSizeData[fontSizeRow]
            sizePicker.removeFromSuperview()
        }
        self.templateViewHeight.constant = (0 + (0.03 * self.view.frame.height))
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }
    @objc func cancelClick() {
        myUIPicker.resignFirstResponder()
    }
    

}


extension UIImage {
    class func imageWithView(view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
}
extension ViewController: UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            self.message = self.txtMessage.text
            textView.resignFirstResponder()
            self.txtMessage.layer.borderWidth = 0
            self.txtMessage.layer.borderColor = UIColor.clear.cgColor
            return false
        }
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.txtMessage.text = self.message
        self.txtMessage.layer.borderWidth = 3
        self.txtMessage.layer.borderColor = UIColor.black.cgColor
    }
    @objc func userDragged(gesture: UIPanGestureRecognizer){
        let loc = gesture.location(in: self.view)
        self.txtMessage.center = loc
        
    }
}
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == sizePicker{
            pickerView.subviews.forEach ({
                
                $0.isHidden = $0.frame.height < 1.0
            })
        }
        
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == myUIPicker{
            return pickerData.count
        }
        else{
            return textSizeData.count
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        if pickerView == myUIPicker{
            let pickerLabel = UILabel()
            pickerLabel.textColor = UIColor.black
            pickerLabel.text = pickerData[row]
            pickerLabel.font = UIFont(name: pickerData[row], size: 15) // In this use your custom font
            pickerLabel.textAlignment = NSTextAlignment.center
            return pickerLabel
        }
        else{
            let sizeLabel = UILabel()
            sizeLabel.textColor = UIColor.black
            sizeLabel.text = String(textSizeData[row])
            sizeLabel.textAlignment = NSTextAlignment.center
            sizeLabel.transform = CGAffineTransform(rotationAngle: 90 * (.pi/180))
            return sizeLabel
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == myUIPicker{
            fontStyleRow = row
            txtMessage.font = UIFont(name: pickerData[row], size: CGFloat(textSize))
        }
        if pickerView == sizePicker{
            fontSizeRow = row
            let size = CGFloat(textSizeData[row])
            txtMessage.font = UIFont(name: fontStyle, size: size )
            
        }
        
    }
    func configureTextEditiorControls(sender:Any){
        
        self.templateViewHeight.constant = (0 - (0.15 * self.view.frame.height))
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
        
    }
    func addFontStyle(){
        
        myUIPicker = UIPickerView(frame: CGRect(x: self.view.bounds.minX , y: self.view.bounds.minY + 30, width: self.view.bounds.width, height: self.textControlsView.bounds.height - 30))
        myUIPicker.delegate = self
        myUIPicker.dataSource = self
        
       
        if fontStyleRow > -1 {
            myUIPicker.selectRow(fontStyleRow, inComponent: 0, animated: true)
        }
         addToolbar(heading: "Change Font Style")
        self.textControlsView.addSubview(myUIPicker)
        
    }
    
    func AddTextColor(){
        
        let allViewsInXibArray = Bundle.main.loadNibNamed("colorPalleteView", owner: self, options: nil)
        myView = allViewsInXibArray?.first as! ColorPalleteView
        myView.frame = CGRect(x: self.view.bounds.minX, y: self.view.bounds.minY + 30, width: self.view.bounds.width, height: self.textControlsView.bounds.height - 30)
        addToolbar(heading: "Change Font Color")
        myView.controller = self.self
        self.textControlsView.addSubview(myView)
        
    }
    
    func addTextSize(){
        let rotaionAngle = -90 * (CGFloat.pi/180)
        let y = self.view.bounds.minY + 30
        sizePicker = UIPickerView()
        sizePicker.transform = CGAffineTransform(rotationAngle: rotaionAngle)
        sizePicker.frame =  CGRect(x: -60 , y: y, width: self.textControlsView.bounds.width + 100, height: self.textControlsView.bounds.height - 30)
        sizePicker.delegate = self
        sizePicker.dataSource = self
        sizePicker.selectRow(textSize, inComponent: 0, animated: false)
        addToolbar(heading: "Change Font Size")
        self.textControlsView.addSubview(sizePicker)
    }
    
    func addToolbar(heading : String){
        let toolBar = UIToolbar(frame: CGRect(x: self.view.bounds.minX, y: self.view.bounds.minY, width: textControlsView.bounds.width, height: 30))
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        let headingLabel = UIBarButtonItem(title: heading, style: .plain, target:self, action: nil)
        headingLabel.tintColor = UIColor.black
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneClick))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([headingLabel,spaceButton, doneButton], animated: false)
        self.textControlsView.bringSubview(toFront: toolBar)
        self.textControlsView.addSubview(toolBar)
    }
}


