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
            scrollView.delegate = self
            scrollView.contentSize = imageView.bounds.size
            scrollView.backgroundColor = UIColor.blueColor()
           setImageSize()
            
        }
    }
    private var hidden = false
    @IBAction func imageTapped(sender: UITapGestureRecognizer) {
        if sender.state == .Ended{
            self.navigationController?.setNavigationBarHidden(!hidden, animated: true)
            hidden = !hidden
            setNeedsStatusBarAppearanceUpdate()

            print(hidden)
        }
    }
    private var imageView = UIImageView()
    
    var product:Product?{
        didSet{
            setImage()
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return hidden
    }
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return .Slide
    }
    
    private func setImageSize(){
        scrollView.maximumZoomScale = 1.0
        
        let imageHeight = imageView.bounds.size.height
        let imageWidth = imageView.bounds.size.width
        let viewHeight = UIScreen.mainScreen().bounds.height
        let viewWidth = UIScreen.mainScreen().bounds.width
        
        let wScale = viewWidth/imageWidth
        let hScale = viewHeight/imageHeight
        scrollView.minimumZoomScale = min(wScale,hScale)
        scrollView.zoomScale = min(wScale,hScale)
        
        
        scrollView.contentOffset.y = wScale < imageHeight ? (viewHeight - imageHeight)/2 :0
        scrollView.contentOffset.x = hScale < imageWidth ? (viewWidth - imageWidth)/2 : 0
        
        
        
//        let minz = scrollView.minimumZoomScale
//        let zs = scrollView.zoomScale
        
//        print(minz)
//        print(zs)
/*
        let pomer = imageHeight/imageWidth
        
        
        //pokud se to přizpůsobí na vysku
        if pomer > viewHeight/viewWidth {
            imageView.frame.size.height = viewHeight
            imageView.frame.size.width = imageView.bounds.size.height/pomer
        
            scrollView.minimumZoomScale = viewHeight/imageHeight
            print("minimum zoom scale: \(scrollView.minimumZoomScale)")
        }
        else{
            imageView.frame.size.width = viewWidth
            imageView.frame.size.height = pomer*imageView.bounds.size.width
            
            scrollView.minimumZoomScale = viewWidth/imageWidth
            print("minimum zoom scale: \(scrollView.minimumZoomScale)")

        }
        
        print("scrollview content size: \(scrollView.contentSize)")*/

    }
    
    private func setImage(){
        imageView.image = UIImage(data: (product?.imagePath)!) //TODO: chybi obrazek
        imageView.sizeToFit()
        //scrollView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        scrollView?.contentSize = imageView.bounds.size
    }
    func scrollViewDidZoom(scrollView: UIScrollView) {
        let imageHeight = imageView.bounds.size.height
        let imageWidth = imageView.bounds.size.width
        let viewHeight = UIScreen.mainScreen().bounds.height
        let viewWidth = UIScreen.mainScreen().bounds.width
        
        let wScale = viewWidth/imageWidth
        let hScale = viewHeight/imageHeight
        scrollView.contentOffset.y = wScale < imageHeight ? (viewHeight - imageHeight)/2 :0
        scrollView.contentOffset.x = hScale < imageWidth ? (viewWidth - imageWidth)/2 : 0
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
        self.tabBarController?.tabBar.hidden = true
    }
    

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        print(hidden)
        setNeedsStatusBarAppearanceUpdate()
        print(hidden)
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
