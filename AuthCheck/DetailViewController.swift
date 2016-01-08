//
//  DetailViewController.swift
//  AuthCheck
//
//  Created by Karanveer Singh Brar on 05/01/16.
//  Copyright © 2016 Karanveer Singh Brar. All rights reserved.
//

import UIKit
import Haneke

class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var imageView1: UIImageView!
    
    var photo: NSDictionary?
    
    //var image1:UIImage = UIImage()
    var animator:UIDynamicAnimator!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //self.view.addSubview(self.imageView1)
        
        // Do any additional setup after loading the view.
        //downloadFromUrl(url)
        let tap = UITapGestureRecognizer(target: self, action: Selector("close:"))
        self.view.addGestureRecognizer(tap)
        self.view.userInteractionEnabled = true
        
        animator = UIDynamicAnimator(referenceView: self.view)
        let snap:UISnapBehavior = UISnapBehavior(item: self.imageView1, snapToPoint: self.view.center)
        self.animator.addBehavior(snap)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        if let photo = photo {
            let url1 = (photo["images"]!["standard_resolution"]!!["url"])! as! String
            let url:NSURL = NSURL(string: url1 as String)!
            downloadFromUrl(url)
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func downloadFromUrl(url: NSURL) {
        self.imageView1.hnk_setImageFromURL(url)
        let config:NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session:NSURLSession = NSURLSession(configuration: config)
        let request:NSURLRequest = NSURLRequest(URL: url)
        let task = session.downloadTaskWithRequest(request) { (location, response, error) -> Void in
            
            let data:NSData = NSData(contentsOfURL: location!)!
            let image:UIImage = UIImage(data: data)!
    
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                //self.image1 = image
                //print(self.image1)
                //print(url)
                self.imageView1.image = image
                
            })
        }

        task.resume()
    }
    
    
    func close(tap: UITapGestureRecognizer) {
        
        self.animator.removeAllBehaviors()
        let snap:UISnapBehavior = UISnapBehavior(item: self.imageView1, snapToPoint: CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(self.view.bounds) + 180.0))
        self.animator.addBehavior(snap)
        
        self.dismissViewControllerAnimated(true, completion: nil)
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
