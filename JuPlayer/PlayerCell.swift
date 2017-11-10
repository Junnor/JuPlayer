//
//  PlayerCell.swift
//  JuPlayer
//
//  Created by nyato on 2017/11/10.
//  Copyright © 2017年 moelove. All rights reserved.
//

import UIKit
import Kingfisher

class PlayerCell: UITableViewCell {

    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var videoTitleLabel: UILabel!
    
    var playButton: UIButton!    // added to imageview

    var playing = false
    
    var playAction: ((UIButton) -> Void)?
    
    var video: VideoModel! {
        didSet {
            if video != nil {
                if let url = URL(string: video.coverForFeed) {
                    let r = ImageResource(downloadURL: url, cacheKey: url.absoluteString)
                    videoImageView.kf.setImage(with: r)
                }
                
                videoTitleLabel.text = video.title
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
        
        layoutIfNeeded()
        
        videoImageView.tag = 101

        playButton = UIButton(type: .custom)
        playButton.setImage(#imageLiteral(resourceName: "video_list_cell_big_icon"), for: .normal)
        playButton.addTarget(self, action: #selector(play(sender:)), for: .touchUpInside)

        videoImageView.addSubview(playButton)
        
        playButton.translatesAutoresizingMaskIntoConstraints = false  // add it, or layout anchors not work
        playButton.centerXAnchor.constraint(equalTo: videoImageView.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: videoImageView.centerYAnchor).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func performAutoPlay() {
        play(sender: self.playButton)
    }
    
    @objc private func play(sender: UIButton) {
        if self.playAction != nil {
            self.playAction!(sender)
        }
    }

}
