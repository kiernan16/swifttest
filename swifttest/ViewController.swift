//
//  ViewController.swift
//  swifttest
//
//  Created by Nielsen on 12/30/16.
//  Copyright © 2016 Nielsen. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var button: UIButton!
    
    var compareNumber = -1
    
    let urlArray: [String] = ["https://robohash.org/123.png",
                              "http://pngimg.com/upload/lamborghini_PNG10694.png",
                              "http://pngimg.com/upload/frog_PNG3848.png",
                              "http://pngimg.com/upload/ship_PNG5403.png",
                              "http://vignette1.wikia.nocookie.net/pepe-the-frog/images/a/a3/Sad_Pepe.png/revision/latest?cb=20150909150849"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
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
    
        print(imageView.image as Any)
    }


    func getRandNumber() -> Int {
        
        var randNumber = Int(arc4random_uniform(UInt32(urlArray.count)))
        
        while randNumber == compareNumber {
            randNumber = Int(arc4random_uniform(UInt32(urlArray.count)))
        }
        
        compareNumber = randNumber
        
        
        return randNumber
    }
}

