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

    lazy var playerView: ZFPlayerView! = {
        let player = ZFPlayerView.shared()
        player?.delegate = self
        player?.cellPlayerOnCenter = false
        player?.stopPlayWhileCellNotVisable =  true
        return player
    }()
    
    lazy var controlView: ZFPlayerControlView! = {
        return ZFPlayerControlView()
    }()

    var playAction: (() -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(playerView)
    }
    
    // play
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        configurePlay()
    }
    
    
    private func configurePlay() {
        
        if playAction != nil {
            playAction!()
        }
    }


}

extension PlayerViewController: ZFPlayerDelegate {
    
}
