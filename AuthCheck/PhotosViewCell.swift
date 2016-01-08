//
//  PhotosViewCell.swift
//  AuthCheck
//
//  Created by Karanveer Singh Brar on 25/12/15.
//  Copyright © 2015 Karanveer Singh Brar. All rights reserved.
//

import UIKit
import Kingfisher
import Haneke

class PhotosViewCell: UICollectionViewCell {

    
    @IBOutlet weak var imageView: UIImageView!
    
    
    var photoSet: NSDictionary?
    var photo: NSDictionary? {
        set {
            photoSet = newValue
            let url1 = (photo!["images"]!["thumbnail"]!!["url"])! as! String
            let url:NSURL = NSURL(string: url1 as String)!
            //print("adasd: \(url)")
            downloadFromUrl(url)

        }
        get {
            return photoSet
        }
    }
    
    
    override func layoutSubviews() {
        self.imageView?.frame = self.contentView.bounds
    }
    
    
    func downloadFromUrl(url: NSURL) {
        self.imageView.hnk_setImageFromURL(url)
        let config:NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session:NSURLSession = NSURLSession(configuration: config)
        let request:NSURLRequest = NSURLRequest(URL: url)
        let task = session.downloadTaskWithRequest(request) { (location, response, error) -> Void in

            let data:NSData = NSData(contentsOfURL: location!)!
            let image:UIImage = UIImage(data: data)!

            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.imageView.image = image
                let tap = UITapGestureRecognizer(target: self, action: Selector("like:"))
                tap.numberOfTapsRequired = 2
                self.imageView.addGestureRecognizer(tap)
                self.imageView.userInteractionEnabled = true
            })
        }
        
        
        task.resume()
        

    }
    
    func like(tap: UITapGestureRecognizer) {
        print("Link is \(self.photo!["link"]!)")
        
        let accessToken = NSUserDefaults.standardUserDefaults().objectForKey("accessToken") as! String
        let photoID = self.photo!.objectForKey("id") as! String
        
        let config:NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session:NSURLSession = NSURLSession(configuration: config)
        let urlString: NSString = NSString(string: "https://api.instagram.com/v1/media/\(photoID)/likes?access_token=\(accessToken)")
        let url:NSURL = NSURL(string: urlString as String)!
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        let task:NSURLSessionDataTask = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                 let alert = UIAlertController(title: "Liked", message: nil, preferredStyle: .Alert)
                UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
                
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC)))
                dispatch_after(time, dispatch_get_main_queue() ) { () -> Void in
                    alert.dismissViewControllerAnimated(true, completion: nil)

                }

            })
 
        }
        task.resume()
  
    }
    
}

/*    if let httpResponse = response as? NSHTTPURLResponse {
print(httpResponse)
} else {
assertionFailure("unexpected response")
}
do {
let text:NSString? = try NSString(contentsOfURL: location!, encoding: NSUTF8StringEncoding)
print(text!)
} catch {
print(error)
}
*/
