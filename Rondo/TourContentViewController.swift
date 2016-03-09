//
//  TourContentViewController.swift
//  FidorBank-iOS
//
//  Created by Jordan Arenas, Jorge on 02/11/15.
//  Copyright © 2015 GFT. All rights reserved.
//

import Foundation
import MediaPlayer

class TourContentViewController: UIViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var iPhoneImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var screenshotView: UIImageView!
    
    var viewModel:TourViewModel = TourViewModel()
    var pageIndex: Int = 0
    var titleText: String = ""
    var subtitleText: String = ""
    var nextText: String = ""
    
    var videoName: String = ""
    var videoScreenShot: String = ""
    var moviePlayer : MPMoviePlayerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenshotView.image = UIImage(named: viewModel.screenShot)
        titleLabel.font = UIFont.systemFontOfSize(UIFont.heightForTutorialTitle)
        subtitleLabel.font = UIFont.systemFontOfSize(UIFont.heightForTutorialSubtitle)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerNotification:", name: MPMoviePlayerReadyForDisplayDidChangeNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        videoName = viewModel.videoName
        screenshotView.alpha = 1.0
        prepareVideo()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        moviePlayer?.stop()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        moviePlayer!.view.frame = videoView.bounds
    }
        
    func prepareVideo() {
        let fileName = videoName.componentsSeparatedByString(".")
        let path = NSBundle.mainBundle().pathForResource(fileName[0], ofType:fileName[1])
        if let url: NSURL? = NSURL.fileURLWithPath(path!) {
            moviePlayer = MPMoviePlayerController(contentURL: url)
            moviePlayer!.view.frame = videoView.bounds
            moviePlayer!.controlStyle = MPMovieControlStyle.None
            videoView.addSubview(moviePlayer!.view)
            moviePlayer?.prepareToPlay()
            videoView.setNeedsLayout()
        }
    }
    
    func playerNotification(notification: NSNotification) {
        if notification.object === moviePlayer {
            if let player = moviePlayer where player.isPreparedToPlay {
                screenshotView.alpha = 0.0
                player.play()
            }
        }
    }
}