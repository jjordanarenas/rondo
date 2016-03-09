	//
//  TourViewController.swift
//  FidorBank-iOS
//
//  Created by Jordan Arenas, Jorge on 02/11/15.
//  Copyright © 2015 GFT. All rights reserved.
//

import UIKit
    
@objc protocol TourViewDelegate {
    func tourViewDidSkip(tour: UIViewController)
    func tourViewDidLogin(tour: UIViewController)
    func tourContentViewDidNext(tour: TourViewController)
    func tourContentViewDidRegister(tour: TourViewController, tourContent: TourContentViewController)
}

class TourViewController: FDViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
 
    @IBOutlet weak var backgroundImageBottomConstraint: NSLayoutConstraint!
    weak var delegate: TourViewDelegate?
    var pageViewController: UIPageViewController!
    var pages = [TourContentViewController]()
    var currentIndex = 0
    var previousIndex = -1

    let pageTitles = [NSLocalizedString("start1_label_text1", comment: ""), NSLocalizedString("start2_label_text1", comment: ""), NSLocalizedString("start3_label_text1", comment: "")]
    let pageSubtitles = [NSLocalizedString("start1_label_text2", comment: ""), NSLocalizedString("start2_label_text2", comment: ""), NSLocalizedString("start3_label_text2", comment: "")]
    let pageNextTexts = [NSLocalizedString("global_next", comment: ""), NSLocalizedString("global_next", comment: ""), NSLocalizedString("global_register", comment: "")]
    let pageNextVideos = [NSLocalizedString("tour-1-XL.mp4", comment: ""), NSLocalizedString("tour-2-XL.mp4", comment: ""), NSLocalizedString("tour-3-XL.mp4", comment: "")]
    let pageVideoScreenshots = [NSLocalizedString("page1_screenshot", comment: ""), NSLocalizedString("page2_screenshot", comment: ""), NSLocalizedString("page3_screenshot", comment: "")]

    private let MAX_NUM_PAGES = 3
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var registerButton: UIButton!
    
        required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializePageViewController()
        backgroundImageBottomConstraint.constant = bottomHeight
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = (viewController as? TourContentViewController)?.pageIndex
            where currentIndex < pageTitles.count - 1 else { return nil }
        return viewControllerAtIndex(currentIndex + 1)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = (viewController as? TourContentViewController)?.pageIndex
            where currentIndex > 0 else { return nil }
        return viewControllerAtIndex(currentIndex - 1)
    }
    
    func viewControllerAtIndex(index : Int) -> UIViewController? {
        
        if((pageTitles.count == 0) || (index >= pageTitles.count)) {
            return nil
        }
        
        var pageContentViewController: TourContentViewController?
        
        if pages.count >= index + 1 {
            pageContentViewController = pages[index]
        } else {
            pageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TourContentViewController") as? TourContentViewController
            pageContentViewController!.viewModel.title = pageTitles[index]
            pageContentViewController!.viewModel.subtitle = pageSubtitles[index]
            pageContentViewController!.viewModel.nextButtonText = pageNextTexts[index]
            pageContentViewController!.viewModel.videoName = pageNextVideos[index]
            pageContentViewController!.viewModel.screenShot = pageVideoScreenshots[index]
            pageContentViewController!.pageIndex = index
            
            pages.append(pageContentViewController!)
        }
        return pageContentViewController
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pageTitles.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func initializePageViewController() {
        
        pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TourViewController") as! UIPageViewController
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        pageControl.numberOfPages = pageTitles.count;
        
        self.addChildViewController(pageViewController)
        self.view.insertSubview(pageViewController.view, atIndex: 1)
        
        pageViewController.didMoveToParentViewController(self)
    }
    
    @IBAction func skipButtonAction(sender: AnyObject) {
        delegate?.tourViewDidSkip(self)
    }
    
    @IBAction func loginButtonAction(sender: AnyObject) {
        delegate?.tourViewDidLogin(self)
    }
    
    @IBAction func registertButtonAction(sender: AnyObject) {
        let pageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TourContentViewController") as! TourContentViewController
        if currentIndex == MAX_NUM_PAGES - 1 {
            delegate?.tourContentViewDidRegister(self, tourContent: pageContentViewController)
        } else {
            delegate?.tourContentViewDidNext(self)
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
            
        let nextViewController = pendingViewControllers[0] as! TourContentViewController
        
        currentIndex = nextViewController.pageIndex
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if !completed {
            return
        }
        updateCurrentIndex(currentIndex)
    }
    
    func updateCurrentIndex(index : Int) {
        pageControl.currentPage = index
        registerButton.setTitle(pages[index].viewModel.nextButtonText, forState: UIControlState.Normal)
        currentIndex = index
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let pageContentViewController = self.viewControllerAtIndex(0)
        pageViewController.setViewControllers([pageContentViewController!], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        updateCurrentIndex(currentIndex)

        UIApplication.sharedApplication().statusBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().statusBarHidden = false
    }
    
    var bottomHeight : CGFloat {
        return 86 + UIFont.heightForTutorialTitle + 20 + 2 * UIFont.heightForTutorialSubtitle + 64
    }
}