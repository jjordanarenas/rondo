//
//  TshirtContentViewController.swift
//  Rondo
//
//  Created by Jorge Jordán on 02/12/15.
//  Copyright © 2015 Insane Platypus Games. All rights reserved.
//

import Foundation
import UIKit

class TshirtContentViewController: UIViewController {
    //@IBOutlet weak var backgroundImageView: UIImageView!
    //@IBOutlet weak var iPhoneImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    //@IBOutlet weak var subtitleLabel: UILabel!
    //@IBOutlet weak var videoView: UIView!
    //@IBOutlet weak var screenshotView: UIImageView!
    
    var viewModel:TshirtViewModel = TshirtViewModel()
    var pageIndex: Int = 0
    var titleText: String = ""
    var fileName: String = ""
    //var subtitleText: String = ""
    //var nextText: String = ""
    
    //var videoName: String = ""
    //var videoScreenShot: String = ""
    //var moviePlayer : MPMoviePlayerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //screenshotView.image = UIImage(named: viewModel.screenShot)
        ///////titleLabel.font = UIFont.systemFontOfSize(UIFont.heightForTutorialTitle)
        //subtitleLabel.font = UIFont.systemFontOfSize(UIFont.heightForTutorialSubtitle)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //////////viewModel.retrieveTshirtsFromFile(fileName)
       ////// titleLabel.text = viewModel.title
//        subtitleLabel.text = viewModel.subtitle
//        videoName = viewModel.videoName
//        screenshotView.alpha = 1.0
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}