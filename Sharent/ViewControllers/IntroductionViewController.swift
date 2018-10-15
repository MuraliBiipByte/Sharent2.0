//
//  IntroductionViewController.swift
//  Sharent
//
//  Created by Biipbyte on 30/07/18.
//  Copyright © 2018 Biipbyte. All rights reserved.
//

import UIKit

class IntroductionViewController: UIViewController, UIScrollViewDelegate
{
    
    var scrollView:UIScrollView!
    @IBOutlet weak var backgroundView:UIView!
    @IBOutlet weak var pageControl:UIPageControl!
    @IBOutlet weak var skipButton:UIButton!
    @IBOutlet weak var doneButton:UIButton!
    
    var imageView:UIImageView!
    var images = [String]()
    var frame = CGRect()
    
    var imagesCount = Int()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        doneButton.layer.cornerRadius = 5.0
        doneButton.layer.masksToBounds = true
        
        skipButton.layer.cornerRadius = 5.0
        skipButton.layer.masksToBounds = true
        
        images = ["userguide1", "userguide2", "userguide3", "userguide4"]
        
        imagesCount = images.count
        
        configurePageControl()
        
        scrollView = UIScrollView(frame: CGRect(x:0, y:20, width:self.view.frame.width,height: self.view.frame.height-69))
        self.view.addSubview(scrollView)
        
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        
        for index in 0..<images.count
        {
            imageView = UIImageView(frame: CGRect(x:self.view.frame.width * CGFloat(index), y:20, width:self.view.frame.width,height: self.view.frame.height-69))
            imageView.contentMode = .scaleAspectFill
            imageView.image = UIImage(named: "\(images[index])")
            self.scrollView.addSubview(imageView)
        }
        
        self.scrollView.contentSize = CGSize(width:self.scrollView.frame.width * CGFloat(imagesCount),height: self.scrollView.frame.height)
        
        doneButton.isHidden = true
    }
    
    func configurePageControl()
    {
        
        self.pageControl.numberOfPages = images.count
        self.pageControl.currentPage = 0
        self.pageControl.pageIndicatorTintColor = UIColor.lightGray
        self.pageControl.currentPageIndicatorTintColor = Constants.APP_COLOR
        self.pageControl.isEnabled = false
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
        
        if Int(pageNumber) == images.count-1
        {
            doneButton.isHidden = false
            skipButton.isHidden = true
        }
        else
        {
            doneButton.isHidden = true
            skipButton.isHidden = false
        }
    }
    
    
     @IBAction func btn_skip_Tapped()
     {
        UserDefaults.standard.set(true, forKey: "introduction_Flag")
        initialvc()
     }
    
    @IBAction func btn_done_Tapped()
    {
        UserDefaults.standard.set(true, forKey: "introduction_Flag")
        initialvc()
    }
    
    func initialvc()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
         appDelegate.rootclassVc()
    }
}

