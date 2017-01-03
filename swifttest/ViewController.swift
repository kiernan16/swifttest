//
//  ViewController.swift
//  swifttest
//
//  Created by Nielsen on 12/30/16.
//  Copyright © 2016 Nielsen. All rights reserved.
//

import UIKit
import Photos


class ViewController: UIViewController {

//MARK: - Declarations
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var button: UIButton!
    
    var compareNumber = -1
    
    let urlArray: [String] = ["https://robohash.org/123.png",
                              "http://pngimg.com/upload/lamborghini_PNG10694.png",
                              "http://pngimg.com/upload/frog_PNG3848.png",
                              "http://pngimg.com/upload/ship_PNG5403.png",
                              "http://16004-presscdn-0-50.pagely.netdna-cdn.com/wp-content/uploads/Labor-force-copy-575x541.jpg",
                              "http://vignette1.wikia.nocookie.net/pepe-the-frog/images/a/a3/Sad_Pepe.png/revision/latest?cb=20150909150849"]
    
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
    
      //  print(imageView.image as Any)
    
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
                print("You saved image")
             
                self.saveImage()
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
    
    func saveImageToPhotos(image: UIImage, to album: PHAssetCollection) {
        PHPhotoLibrary.shared().performChanges({
            // Request creating an asset from the image.
            let creationRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            // Request editing the album.
            guard let addAssetRequest = PHAssetCollectionChangeRequest(for: album)
                else { return }
            // Get a placeholder for the new asset and add it to the album editing request.
            addAssetRequest.addAssets([creationRequest.placeholderForCreatedAsset!] as NSArray)
        }, completionHandler: { success, error in
            if !success { NSLog("error creating asset: \(error)") }
        })
    }
    
    func saveImage () {
        let albumName:String = "swifttest"
        var collection:PHAssetCollection!
        var options:PHFetchOptions = PHFetchOptions()
        options.predicate = NSPredicate(format: "estimatedAssetCount >= 0")
        
        var userAlbums:PHFetchResult = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.album, subtype: PHAssetCollectionSubtype.any, options: options)
        
        var assetCollectionPlaceholder:PHObjectPlaceholder!
        PHPhotoLibrary.shared().performChanges({
            let request = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
            assetCollectionPlaceholder = request.placeholderForCreatedAssetCollection
        },
        
            completionHandler: { (success:Bool, Error:Error?) in
                if (success) {
                    var result:PHFetchResult = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [assetCollectionPlaceholder.localIdentifier], options: nil)
                    collection = result.firstObject! as PHAssetCollection
                }
        })
        
        userAlbums.enumerateObjects(using: { (object: AnyObject!, count: Int, stop: UnsafeMutablePointer) in
            if object is PHAssetCollection {
                let obj:PHAssetCollection = object as! PHAssetCollection
                if (obj.localizedTitle == albumName) {
                    collection = obj
                    stop.initialize(to: true)
                }
            }
        })
     
        self.saveImageToPhotos(image: self.imageView.image!, to: collection)
        
    }
    
}

