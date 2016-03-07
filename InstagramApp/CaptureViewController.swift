//
//  CaptureViewController.swift
//  InstagramApp
//
//  Created by Veronika Kotckovich on 3/6/16.
//  Copyright © 2016 Veronika Kotckovich. All rights reserved.
//

import UIKit
import Parse

class CaptureViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var instaImage: UIImageView!
    
    @IBOutlet weak var capture: UITextView!
    
    let vc = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vc.delegate = self
        
        capture.delegate = self

        capture.text = "Caption"
        capture.textColor = UIColor.grayColor()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y -= keyboardSize.height
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y += keyboardSize.height
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCamera(sender: AnyObject) {
       
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.Camera
        
        self.presentViewController(vc, animated: true, completion: nil)
        
    }

    @IBAction func onLibrary(sender: AnyObject) {
  
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    

    
    @IBAction func onSubmit(sender: AnyObject) {
        
        print("on submit")
        let newImage = Post.resize(instaImage.image!, newSize: CGSize(width: 300, height: 500))
        Post.postUserImage(newImage, withCaption: capture.text) { (success: Bool, error: NSError?) -> Void in
            print(" after postImage")
            if success {
                print("Submit")
                self.instaImage.image = UIImage(named:"noImage")!
                self.capture.text = nil
                self.tabBarController?.selectedIndex = 1
            } else {
                print("Sorry! Error posting image to DB")
            }
            
        }
        
    }
    
  //  func imagePickerController(picker: UIImagePickerController,
   //     didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            // Get the image captured by the UIImagePickerController
    
    func imagePickerController(
        picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        instaImage.contentMode = .ScaleAspectFit //3
        instaImage.image = chosenImage //4
        dismissViewControllerAnimated(true, completion: nil) //5
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //text view methods
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        if capture.textColor == UIColor.grayColor() {
            capture.text = nil
            capture.textColor = UIColor.blackColor()
            print("i am in begin")
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if capture.text.isEmpty {
            capture.text = "Caption"
           capture.textColor = UIColor.grayColor()
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
