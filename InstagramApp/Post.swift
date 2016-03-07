//
//  Post.swift
//  InstagramApp
//
//  Created by Veronika Kotckovich on 3/6/16.
//  Copyright © 2016 Veronika Kotckovich. All rights reserved.
//

import UIKit
import Parse

class Post: NSObject {
    
    class func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRectMake(0, 0, newSize.width, newSize.height))
        resizeImageView.contentMode = UIViewContentMode.ScaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /**
     Method to add a user post to Parse (uploading image file)
     
     - parameter image: Image that the user wants upload to parse
     - parameter caption: Caption text input by the user
     - parameter completion: Block to be executed after save operation is complete
     */
    
    
    class func postUserImage(image: UIImage?, withCaption caption: String?, withCompletion completion: PFBooleanResultBlock?) {
        // Create Parse object PFObject
        let posty = PFObject(className: "Post")
        
        print("Posting user image")
        
        // Add relevant fields to the object
        posty["media"] = getPFFileFromImage(image) // PFFile column type
        posty["author"] = PFUser.currentUser() // Pointer column type that points to PFUser
        posty["caption"] = caption
        posty["likesCount"] = 0
        posty["commentsCount"] = 0
        
        // Save object (following function will save the object in Parse asynchronously)
        print("user image save complete")
        posty.saveInBackgroundWithBlock(completion)
    }
    
    /**
     Method to convert UIImage to PFFile
     
     - parameter image: Image that the user wants to upload to parse
     
     - returns: PFFile for the the data in the image
     */
    
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }


}
