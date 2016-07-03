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
            scrollView.backgroundColor = UIColor.whiteColor()
            setImageSize()
            scrollView.zoomScale = scrollView.minimumZoomScale
            
            adjustInset()
            
        }
    }
    private var hidden = false
    @IBAction func imageTapped(sender: UITapGestureRecognizer) {
        if sender.state == .Ended{
            self.navigationController?.setNavigationBarHidden(!hidden, animated: true)
            hidden = !hidden
            setNeedsStatusBarAppearanceUpdate()
            scrollView.backgroundColor = hidden ? UIColor.blackColor() : UIColor.whiteColor()
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
        return .Fade
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
        
        

    }
    
    private func adjustInset(){
        let imageHeight = imageView.bounds.size.height
        let imageWidth = imageView.bounds.size.width
        let viewHeight = UIScreen.mainScreen().bounds.height
        let viewWidth = UIScreen.mainScreen().bounds.width
        let wScale = viewWidth/imageWidth
        let hScale = viewHeight/imageHeight
        let topInset = (wScale < hScale || min(wScale,hScale) > 1) ? (viewHeight - (scrollView.zoomScale*imageHeight))/2 : 0
        let leftInset = (hScale < wScale || min(wScale,hScale) > 1) ? (viewWidth - (scrollView.zoomScale*imageWidth))/2 : 0
        
        scrollView.contentInset.top = topInset
        scrollView.contentInset.left = leftInset
        
    }
    
    private func setImage(){
        imageView.image = UIImage(data: (product?.imagePath)!) //TODO: chybi obrazek
        imageView.sizeToFit()
        scrollView?.contentSize = imageView.bounds.size
    }
    func scrollViewDidZoom(scrollView: UIScrollView) {
       adjustInset()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
        self.tabBarController?.tabBar.hidden = true
        self.title = product?.name
    }
    

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setImageSize()
        scrollView.zoomScale = scrollView.minimumZoomScale > scrollView.zoomScale ? scrollView.minimumZoomScale : scrollView.zoomScale
        adjustInset()
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
