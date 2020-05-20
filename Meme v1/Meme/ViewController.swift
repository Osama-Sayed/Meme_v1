//
//  ViewController.swift
//  Meme
//
//  Created by osama on 4/26/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate{
    
    var finalImg : UIImage?
    let topText : String? = "ENTER TOP TEXT"
    let bottomText : String? = "ENTER BOTTOM TEXT"

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var AlbumButton: UIBarButtonItem!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextFiled: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setTextField(textField: topTextField)
        setTextField(textField: bottomTextFiled)
        shareButton.isEnabled = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    @IBAction func cancelMeme(_ sender: Any) {
        topTextField.text = topText
        bottomTextFiled.text = bottomText
        imagePickerView.image = nil
        shareButton.isEnabled = false
    }
    
    @IBAction func ShareButton(_ sender: Any) {
        let genratedImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [genratedImage], applicationActivities: nil)
        
        activityController.completionWithItemsHandler = {activity , success, items, erorr in
            if success {
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
        self.present(activityController, animated: true, completion: nil)
    }
    
    func pickFromSource(_ source: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self;
        imagePickerController.sourceType = source
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func PickImageFromCamera(_ sender: Any) {
       pickFromSource(.camera)
    }
    
    @IBAction func pickImageFromAlbum(_ sender: Any) {
        pickFromSource(.photoLibrary)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage ] as? UIImage{
            imagePickerView.image = image
            shareButton.isEnabled = true
        }else{
            let alert = UIAlertController(title: "Selection Error", message: "Failed To Select Picture",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default"),
                                          style: .default, handler: { _ in
                                            print("Picture Selection Error")
            }))
            self.present(alert, animated: true, completion: nil)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func setTextField (textField :UITextField){
        textField.textAlignment = .center
        let memeTextAttributes: [NSAttributedString.Key :Any] = [NSAttributedString.Key.strokeColor: UIColor.black,
                                                             NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40) ??
                                                                UIFont(name: "Impact", size: 40)!,
                                                             NSAttributedString.Key.foregroundColor: UIColor.white,
                                                             NSAttributedString.Key.strokeWidth: -3.0]
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.backgroundColor = UIColor.clear
        textField.borderStyle = .none
        textField.delegate = self
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "Top" || textField.text == "Bottom"{
            textField.text = ""
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
 
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTextFiled.isEditing{
        view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func save() {
        // Create the meme
        _ = Meme(topText: topTextField.text!, botText: bottomTextFiled.text!, orgImage: imagePickerView.image!, finalImage: finalImg)
    }
    
    func generateMemedImage() -> UIImage {
        
        // TODO: Hide toolbar and navbar
        self.topToolbar.isHidden = true
        self.bottomToolbar.isHidden = true
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let finalImg:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // TODO: Show toolbar and navbar
        self.topToolbar.isHidden = false
        self.bottomToolbar.isHidden = false
        self.finalImg = finalImg
        return finalImg
    }
}

