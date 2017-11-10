//
//  PlayerViewController.swift
//  JuPlayer
//
//  Created by nyato on 2017/11/10.
//  Copyright © 2017年 moelove. All rights reserved.
//

import UIKit
import ZFPlayer

class PlayerViewController: UIViewController {
    
    var videoURL: URL!
    var videoTitle: String!
    
    @IBOutlet weak var playerFatherView: UIView!
    
    
    lazy private var playerModel: ZFPlayerModel! = {
        let model = ZFPlayerModel()
        model.title = "看鬼啊"
        model.videoURL = videoURL
        model.placeholderImage = #imageLiteral(resourceName: "loading_bgView1")
        model.fatherView = playerFatherView
        return model
    }()
    
    lazy private var playerView: ZFPlayerView! = {
        let player = ZFPlayerView()
        player.playerControlView(nil, playerModel: playerModel)
        player.delegate = self
        player.hasDownload = true
        player.autoPlayTheVideo()
        return player
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerModel.videoURL = videoURL
        playerModel.title = videoTitle
        
        playerView.autoPlayTheVideo()
    }
    
}

extension PlayerViewController: ZFPlayerDelegate {
    
}
