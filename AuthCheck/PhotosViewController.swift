//
//  PhotosViewController.swift
//  AuthCheck
//
//  Created by Karanveer Singh Brar on 25/12/15.
//  Copyright © 2015 Karanveer Singh Brar. All rights reserved.
//

import UIKit
import OAuthSwift

//private let reuseIdentifier = "Cell"

class PhotosViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIViewControllerTransitioningDelegate {
    
        var photos:NSArray = []
    
        var accessToken:NSString!
    
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view, typically from a nib.
            
            //array = ["Treehouse"]
            self.title = "InstaManage"
            
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.itemSize = CGSizeMake(106.0, 106.0)
            layout.minimumInteritemSpacing = 1.0
            layout.minimumLineSpacing = 1.0
            
            collectionView?.collectionViewLayout = layout 
            collectionView!.backgroundColor = UIColor.whiteColor()
            
            //self.collectionView?.addGestureRecognizer(tap)
            
            let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
            self.accessToken = userDefaults.stringForKey("accessToken")
            
            let oauthswift = OAuth2Swift(
                consumerKey:    "YourConsumerKey",
                consumerSecret: "YourConsumerSecret",
                authorizeUrl:   "https://api.instagram.com/oauth/authorize",
                responseType:   "token"
            )
            
            if (self.accessToken == nil) {
                oauthswift.authorizeWithCallbackURL(NSURL(string: "authcheck://auth/instagram")!, scope: "public_content+likes", state: "INSTAGRAM", success: { (credential, response, parameters) -> Void in
                    
                    //print(credential.oauth_token)
                    self.accessToken = credential.oauth_token
                    userDefaults.setObject(self.accessToken, forKey: "accessToken")
                    userDefaults.synchronize()
                    self.downloader()
                    },
                    failure: { error in
                        print(error.localizedDescription)
                    }
                    
                )
                
            } else {
                self.downloader()
            }
    }
    
    func downloader() {
        let config:NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session:NSURLSession = NSURLSession(configuration: config)
        let urlString: NSString = NSString(string: "https://api.instagram.com/v1/users/self/media/recent/?access_token=\(self.accessToken)")
        let url:NSURL = NSURL(string: urlString as String)!
        let request:NSURLRequest = NSURLRequest(URL: url)
        let task = session.downloadTaskWithRequest(request) { (location, response, error) -> Void in
            
            
            let data:NSData = NSData(contentsOfURL: location!)!
            do {
                
                let responseDictionary:NSDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                //print(responseDictionary)
                self.photos = responseDictionary.valueForKeyPath("data") as! NSArray
                //print(self.photos)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.collectionView?.reloadData()
                })

                //print(self.photos)
            } catch {
                print(error)
            }
        }
        
        task.resume()

    }
    
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }

    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        assert(sender as? UICollectionViewCell != nil, "sender is not a collection view")
        
        if let indexPath = self.collectionView?.indexPathForCell(sender as! UICollectionViewCell) {
            if segue.identifier == "DetailView1" {
                let detailVC: DetailViewController = segue.destinationViewController as! DetailViewController
                detailVC.modalPresentationStyle = UIModalPresentationStyle.Custom
                detailVC.transitioningDelegate = self
                detailVC.photo = self.photos[indexPath.row] as? NSDictionary
            }
        }
    }
    
    
    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.photos.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! PhotosViewCell
        
        cell.backgroundColor = UIColor.brownColor()

        cell.photo = self.photos[indexPath.row] as? NSDictionary
        
        //self.p = self.photos[indexPath.row] as! NSDictionary
        //print("Link is \(cell.photo!["link"]!)")
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
         //photo = self.photos[indexPath.row] as! NSDictionary
        
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) {
            performSegueWithIdentifier("DetailView1", sender: cell)
        }
         //performSegueWithIdentifier("DetailView1", sender: indexPath.row)
        
        
        //let VC1:DetailViewController = DetailViewController()
        
        
        //VC.photo = photo
        //performSegueWithIdentifier("DetailView", sender: self)
        //self.presentViewController(VC, animated: true, completion: nil)
        
        //let VC1:DetailViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("DetailView1") as! DetailViewController
        
        //VC1.modalPresentationStyle = UIModalPresentationStyle.Custom
        //VC1.transitioningDelegate = self
        
        //VC1.photo = photo
        
        //self.presentViewController(VC1, animated: true, completion: nil)
        
        //navigationController?.pushViewController(VC1, animated: true)
        //UIApplication.sharedApplication().keyWindow?.rootViewController!.presentViewController(VC1, animated: true, completion: nil)

        //VC.downloadFromUrl(url)
        
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DetailTransition()
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissDetail()
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
    /* func like(gestureReconizer:UITapGestureRecognizer) {
    
    if gestureReconizer.state != UIGestureRecognizerState.Ended {
    return
    }
    
    let p = gestureReconizer.locationInView(self.collectionView)
    let indexPath = self.collectionView!.indexPathForItemAtPoint(p)
    
    if let index = indexPath {
    _ = self.collectionView!.cellForItemAtIndexPath(index)
    // do stuff with your cell, for example print the indexPath
    let alert:UIAlertController = UIAlertController(title: "Liked", message: nil, preferredStyle: .Alert)
    self.presentViewController(alert, animated: true, completion: nil)
    
    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC)))
    dispatch_after(time, dispatch_get_main_queue() ) { () -> Void in
    alert.dismissViewControllerAnimated(true, completion: nil)
    }
    } else {
    print("Could not find index path")
    }
    }
    */


}
