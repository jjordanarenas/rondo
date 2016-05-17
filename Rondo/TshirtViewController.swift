//
//  TshirtViewController.swift
//  Rondo
//
//  Created by Jorge Jordán on 02/12/15.
//  Copyright © 2015 Insane Platypus Games. All rights reserved.
//

import UIKit

@objc protocol TshirtViewDelegate {
    func tourViewDidSkip(tour: UIViewController)
}

class TshirtViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate {
    
    weak var delegate2: TshirtViewDelegate?
    var pageViewController: UIPageViewController!
    var pageContentViewController: TshirtContentViewController?
    var pages = [TshirtContentViewController]()
    var currentIndex = 0
    var previousIndex = -1
    var pageTitle = ""
    var tshirtsFileName = ""
    let LEAGUES_FILENAME = "Leagues"
    let LEAGUES_FILENAME_TEST = "LeaguesTest"
    
    var arrayFileNames = [AnyObject]()
    var arrayTshirtNames = [AnyObject]()
    
    private var MAX_NUM_PAGES = 0
    
  
    var buttonWidth: CGFloat = 0.0
    var buttonHeight: CGFloat = 0.0
    
    var viewWidth: CGFloat = 0.0
 
    var scrollView: UIScrollView!
    var viewHeight: CGFloat = 0.0
    var horizontalGap: CGFloat = 0.0
    var verticalGap: CGFloat = 0.0
    
    var gapBetweenRows: CGFloat = 0.0
    var gapBetweenColumns: CGFloat = 0.0
    var k_NUM_COLUMNS: Int = 4
    var k_NUM_ROWS: Int = 0

    
    @IBOutlet weak var skipButton: UIButton!
    
    var pageControl: UIPageControl!
  
  
  var leftSwipe = UISwipeGestureRecognizer()
  var rightSwipe = UISwipeGestureRecognizer()
  
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initializeSwipeGestures()
      

    }
  
  func initializeSwipeGestures() {
    leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
    rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
    
    leftSwipe.direction = .Left
    rightSwipe.direction = .Right
    
    view.addGestureRecognizer(leftSwipe)
    view.addGestureRecognizer(rightSwipe)
    
  }

  func handleSwipes(sender:UISwipeGestureRecognizer) {
    if (sender.direction == .Left) {
      print("Swipe Left")
      if currentIndex < MAX_NUM_PAGES - 1 {
        viewControllerAtIndex(currentIndex + 1)
      }
    }
    
    if (sender.direction == .Right) {
      print("Swipe Right")
      if currentIndex > 0 {
        viewControllerAtIndex(currentIndex - 1)
        
      }
      
    }
  }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
//        guard let currentIndex = (viewController as? TshirtContentViewController)?.pageIndex
//            where currentIndex < arrayTshirtNames.count - 1 else { return nil }
      guard let currentIndex = (viewController as? TshirtContentViewController)?.pageIndex
        where currentIndex < arrayFileNames.count - 1 else { return nil }
      
      
      
        return viewControllerAtIndex(currentIndex + 1)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
//        guard let currentIndex = (viewController as? TshirtContentViewController)?.pageIndex
//            where currentIndex > 0 else { return nil }
      guard let currentIndex = (viewController as? TshirtContentViewController)?.pageIndex
        where currentIndex > 0 else { return nil }
        return viewControllerAtIndex(currentIndex - 1)
    }
    
    func viewControllerAtIndex(index : Int) -> UIViewController? {
        
        //if((pageTitles.count == 0) || (index >= pageTitles.count)) {
        if MAX_NUM_PAGES == 0 || index >= MAX_NUM_PAGES {
            return nil
        }
        
        //var pageContentViewController: TshirtContentViewController?
        
        if pages.count >= index + 1 {
            pageContentViewController = pages[index]
        } else {
            pageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TshirtContentViewController") as? TshirtContentViewController
            tshirtsFileName = arrayFileNames[index] as! String
            //pageContentViewController!.viewModel.title = pageTitles[index]
            pageContentViewController!.viewModel.title = pageTitle
            pageContentViewController!.viewModel.fileName = tshirtsFileName
            
            pageContentViewController!.viewModel.retrieveTshirtsFromFile(tshirtsFileName)
            
            //pageContentViewController!.viewModel.subtitle = pageSubtitles[index]
            //pageContentViewController!.viewModel.nextButtonText = pageNextTexts[index]
            //pageContentViewController!.viewModel.videoName = pageNextVideos[index]
            //pageContentViewController!.viewModel.screenShot = pageVideoScreenshots[index]
            pageContentViewController!.pageIndex = index
            
            if (pageContentViewController!.viewModel.arrayTshirts.count%k_NUM_COLUMNS == 0) {
                k_NUM_ROWS = pageContentViewController!.viewModel.arrayTshirts.count/k_NUM_COLUMNS
            } else {
                k_NUM_ROWS = pageContentViewController!.viewModel.arrayTshirts.count/k_NUM_COLUMNS + 1
            }
                       
            
            //guard let currentIndex = (viewController as? TourContentViewController)?.pageIndex
//                where currentIndex < pageTitles.count - 1 else { return nil }
  //          return viewControllerAtIndex(currentIndex + 1)
            
            
            self.initializeAuxVariables()
            self.initializeTShirtsView()

            self.view.addSubview(scrollView)
          
            
            pages.append(pageContentViewController!)
        }
        return pageContentViewController
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return arrayTshirtNames.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func initializePageViewController() {
        var filenamesDictionary: NSDictionary!
        
        // Get level dictionary root
        if let pathToFile = NSBundle.mainBundle().pathForResource(LEAGUES_FILENAME_TEST, ofType: "plist") {
            filenamesDictionary = NSDictionary(contentsOfFile: pathToFile)
            
            arrayFileNames = filenamesDictionary.allValues
            print(arrayFileNames.count)
        }

      
      pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TshirtViewController") as! UIPageViewController
        pageViewController.dataSource = self
        pageViewController.delegate = self
      
        MAX_NUM_PAGES = arrayFileNames.count

      
      pageViewController.view.frame = view!.bounds
      
      

        
      
      
      
          pageControl = UIPageControl()
        pageControl.numberOfPages = MAX_NUM_PAGES
      
        pageControl.tintColor = UIColor.greenColor()
      pageControl.pageIndicatorTintColor = UIColor.grayColor()
      pageControl.currentPageIndicatorTintColor = UIColor.redColor()
      
      pageControl.sizeThatFits(view!.bounds.size)
        addChildViewController(pageViewController)
        //view.insertSubview(pageViewController.view, atIndex: 1)
        view.addSubview(pageViewController.view)
        pageViewController.didMoveToParentViewController(self)
     
    }
    
    @IBAction func skipButtonAction(sender: AnyObject) {
        delegate2?.tourViewDidSkip(self)
    }
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        
        let nextViewController = pendingViewControllers[0] as! TshirtContentViewController
        
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
        //registerButton.setTitle(pages[index].viewModel.nextButtonText, forState: UIControlState.Normal)
        currentIndex = index
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
         initializePageViewController()
        let pageContentViewController = self.viewControllerAtIndex(0)
        pageViewController.setViewControllers([pageContentViewController!], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        updateCurrentIndex(currentIndex)
        
        UIApplication.sharedApplication().statusBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().statusBarHidden = false
    }
    
    func initializeAuxVariables() {
        ////var auxButton: UIButton!
        
        let image = UIImage(named: "fcbarcelona_main") as UIImage?
        /*auxButton = UIButton()//imageNamed: "fcbarcelona_main")
        auxButton.setImage(UIImage(contentsOfFile: "fcbarcelona_main"), forState: UIControlState.Normal)*/
        ///        auxButton.frame.size.width = 50
        ///auxButton.frame.size.height = 50
        //auxButton.frame = CGRectMake(10, 50, 50, 50)
        viewWidth = view!.bounds.size.width
        viewHeight = view!.bounds.size.height
        
        
        horizontalGap = viewWidth - (CGFloat(k_NUM_COLUMNS + 3) * (image?.size.width)!)
        verticalGap = viewHeight - (CGFloat(k_NUM_ROWS + 3) * (image?.size.height)!)
      
        //viewWidth - (CGFloat(k_NUM_ROWS + 3) * auxButton.frame.height)
        
        buttonWidth = (image?.size.width)!
        buttonHeight = (image?.size.height)!
//        buttonWidth = auxButton.frame.width
//        buttonHeight = auxButton.frame.height
        
        //print("\nimage width: \(buttonWidth) image height: \(buttonHeight)")
        //print("\nhorizontalGap: \(horizontalGap)\nverticalGap: \(verticalGap)\n")
        
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.frame = CGRectMake(view!.bounds.origin.x + buttonWidth/2, view!.bounds.origin.y + 3*buttonWidth, view!.bounds.width - buttonWidth, view!.bounds.height - 4*buttonWidth)
      
      scrollView.contentSize.width = scrollView.frame.size.width
      scrollView.contentSize.height = CGFloat(k_NUM_ROWS - 1) * verticalGap/4 + CGFloat(k_NUM_ROWS) * buttonHeight + verticalGap
        scrollView.backgroundColor = UIColor.blueColor()
      
      
        pageViewController.view.backgroundColor = UIColor.greenColor()
    }
    
    func initializeTShirtsView() {
        var xPosition: CGFloat = 0.0
        var yPosition: CGFloat = 0.0
        
        var countTshirts = 0
      
        for row in 0..<k_NUM_ROWS {
            if row == 0 {
                yPosition += 0.5 * verticalGap
            } else {
                yPosition += verticalGap
            }
            
            xPosition = 0.0
            
            for column in 0..<k_NUM_COLUMNS {
                if column == 0 {
                    xPosition += horizontalGap
                } else {
                    xPosition += 3 * horizontalGap
                }
                
                if countTshirts >= pageContentViewController!.viewModel.arrayTshirts.count {
                    break
                }
                //print("ROW: \(row) COLUMN: \(column)")
                //print("POSITION X: \(xPosition)\nPOSITION Y: \(yPosition)")
                
                let button = UIButton(frame: CGRectMake(xPosition, yPosition, buttonWidth, buttonHeight)) // as UIButton
                //    button.setImage(UIImage(contentsOfFile: "fcbarcelona_main"), forState: UIControlState.Normal)
                // pageContentViewController!.viewModel.
                //button.setImage(UIImage(named: "fcbarcelona_main"), forState: UIControlState.Normal)
                
                
                let tshirtName =  pageContentViewController!.viewModel.arrayTshirts[countTshirts] as String
                button.setImage(UIImage(named: tshirtName), forState: UIControlState.Normal)
                button.setTitle("button on row: \(row) column: \(column)", forState: UIControlState.Normal)
                
                button.tag = countTshirts
                button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
                
                
                button.tintColor = UIColor.redColor()
              
              
             scrollView.addSubview(button)
              
                countTshirts++
                
            }
        }
        //pageControl.frame = CGRectMake(view.frame.size.width/2 - buttonWidth/2, yPosition + 0.25 * verticalGap, buttonWidth, buttonHeight)
      pageControl.frame = CGRectMake(view.frame.size.width/2, view.frame.size.height, buttonWidth, buttonHeight)
       // scrollView.addSubview(pageControl)
       scrollView.addSubview(pageControl)
      
    }
    
    func buttonAction(sender:UIButton) {
        print("buttonAction")

        print(sender.tag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}
