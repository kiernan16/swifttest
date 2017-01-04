//
//  ViewController.swift
//  swifttest
//
//  Created by Nielsen on 12/30/16.
//  Copyright © 2016 Nielsen. All rights reserved.
//

import UIKit
import Photos


class RandomImageViewController: UIViewController {

//MARK: - Declarations
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var button: UIButton!
    
    var compareNumber = -1
    var albumName: String = "swifttest"
    
    let urlArray: [String] = ["https://robohash.org/123.png",
                              "http://pngimg.com/upload/lamborghini_PNG10694.png",
                              "http://pngimg.com/upload/frog_PNG3848.png",
                              "http://pngimg.com/upload/ship_PNG5403.png",
                              "http://16004-presscdn-0-50.pagely.netdna-cdn.com/wp-content/uploads/Labor-force-copy-575x541.jpg",
                              "http://vignette1.wikia.nocookie.net/pepe-the-frog/images/a/a3/Sad_Pepe.png/revision/latest?cb=20150909150849",
                              "http://www.maserati.com/mediaObject/sites/international/Models/granturismo/thumbnails/Granturismo-sport/2016-05-31/GT-Sport/resolutions/res-l10000x500/GT-Sport.jpg"]
    
//MARK: - Set up
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(_:)))
        imageView.addGestureRecognizer(longPress)
        imageView.isUserInteractionEnabled = true
        self.view.addSubview(imageView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
//MARK: - IBActions
    @IBAction func didTouchButton (sender: AnyObject) {
        
        let urlString = urlArray[self.getRandNumber()]
        let url = URL(string: urlString)
    
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                }
            } catch {
                print(error)
            }
        }
    }
    

//MARK: - Functions
    func getRandNumber() -> Int {
        
        var randNumber = Int(arc4random_uniform(UInt32(urlArray.count)))
        
        while randNumber == compareNumber {
            randNumber = Int(arc4random_uniform(UInt32(urlArray.count)))
        }
        
        compareNumber = randNumber
        
        return randNumber
    }
    
    // function which is triggered when handleTap is called
    func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        
        if(sender.state == UIGestureRecognizerState.began && imageView.image != nil) {
            print("Started")
            
            let alertController = UIAlertController(title: "Save image to Photos?", message: "Save image to Photos?", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "SAVE", style: UIAlertActionStyle.default)
            {
                (result : UIAlertAction) -> Void in
                self.saveImageToPhotos(image: self.imageView.image!)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
                (alert) -> Void in
                print("Cancelled saved image")
            }
            
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
            
        } else {
            print("Ended")
        }
    }
    
//MARK: Save Image
    func saveImageToPhotos(image: UIImage) {
        let _ = CustomPhotoAlbum.sharedInstance     //hack to save photo if album isn't yet created
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {     //gives us a little bit of time to create album
            CustomPhotoAlbum.sharedInstance.save(image: image)
            print("You saved image")
        }
    }
}

