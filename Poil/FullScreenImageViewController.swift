//
//  FullScreenImageViewController.swift
//  Poil
//
//  Created by Ondrej Mekota on 29/06/16.
//  Copyright © 2016 Ondrej Mekota. All rights reserved.
//

import UIKit

class FullScreenImageViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    {
        didSet{
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.1
            scrollView.maximumZoomScale = 1.0
        }
    }
    
    private var imageView = UIImageView()
    
    var product:Product?{
        didSet{
            setImage()
        }
    }
    
    private func setImage(){
        imageView.image = UIImage(data: (product?.imagePath)!) //TODO: chybi obrazek
        imageView.sizeToFit()
        //scrollView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        scrollView?.contentSize = imageView.bounds.size
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
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
