//
//  ViewController.swift
//  JuPlayer
//
//  Created by nyato on 2017/11/10.
//  Copyright © 2017年 moelove. All rights reserved.
//

import UIKit
import ZFPlayer

class ViewController: UIViewController {
    
    // MARK: UI
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            
            tableView.estimatedRowHeight = 255
            tableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    lazy private var playerView: ZFPlayerView! = {
        let player = ZFPlayerView.shared()
        player?.delegate = self
        player?.cellPlayerOnCenter = false
        player?.stopPlayWhileCellNotVisable =  true
        return player
    }()
    
    lazy private var controlView: ZFPlayerControlView! = {
        return ZFPlayerControlView()
    }()
    
    private var tmpCell: PlayerCell!
    
    
    // MARK: Data
    
    private var allVideo: [VideoModel] = []
    private var viewAppear = false
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global().async {
            self.requestData()
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewAppear = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        playerView?.resetPlayer()
    }
    
    // MARK: Load data
    
    private func requestData() {
        let path = Bundle.main.path(forResource: "videoData", ofType: "json")
        let data = NSData(contentsOfFile: path!)! as Data
        let rootDict = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
        let list = rootDict.value(forKey: "videoList") as! [NSDictionary]
        for item in list {
            let video = VideoModel()
            video.title = item.value(forKey: "title") as! String
            video.videoDescription = item.value(forKey: "description") as! String
            video.coverForFeed = item.value(forKey: "coverForFeed") as! String
            video.playUrl = item.value(forKey: "playUrl") as! String
            
            let playInfo = item.value(forKey: "playInfo") as! [NSDictionary]
            for info in playInfo {
                let resolution = VideoResolution()
                resolution.name = info.value(forKey: "name") as! String
                resolution.type = info.value(forKey: "type") as! String
                resolution.url = info.value(forKey: "url") as! String
                
                resolution.width = info.value(forKey: "width") as! Int
                resolution.height = info.value(forKey: "height") as! Int
                
                video.playInfo.append(resolution)
            }
            allVideo.append(video)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let playervc = segue.destination as! PlayerViewController
        let indexPath = sender as! IndexPath
        let video = allVideo[indexPath.row]
        let urlString = video.playInfo.first!.url
        playervc.videoURL = URL(string: urlString)
        playervc.videoTitle = video.title
    }

}

// MARK: - Table view dataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allVideo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath)
        if let cell = cell as? PlayerCell {
            
            weak var video = allVideo[indexPath.row]
            weak var weakSelf = self
            weak var weakCell = cell
            
            cell.video = video

            cell.playAction =  { sender in
                
                var dic = [String: String]()
                for resolution in video!.playInfo {
                    dic[resolution.name] = resolution.url
                }
                
                let playerUrl = URL(string: video!.playInfo.first!.url)!
                
                let playerModel = ZFPlayerModel()
                playerModel.title = video?.title
                playerModel.videoURL = playerUrl
                playerModel.placeholderImageURLString = video?.coverForFeed
                playerModel.scrollView = weakSelf?.tableView
                playerModel.indexPath = indexPath
                playerModel.resolutionDic = dic
                playerModel.fatherViewTag = weakCell!.videoImageView.tag
                
                weakSelf?.playerView.playerControlView(nil, playerModel: playerModel)
                
                weakSelf?.playerView.hasDownload = true
                weakSelf?.playerView.autoPlayTheVideo()
            }
            
            
        }
        return cell
    }
}

// MARK: - Table view delegate
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "play video", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tmpCell?.playing = false
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        playerScrollView(scrolView: scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        playerScrollView(scrolView: scrollView)
    }
    
    private func playerScrollView(scrolView: UIScrollView) {
        if viewAppear {
            var offset = scrolView.contentOffset
            offset.y += 200
            let visibleCells = tableView.visibleCells as! [PlayerCell]
            let indexPath = tableView.indexPathForRow(at: offset)!
            tmpCell = tableView.cellForRow(at: indexPath) as! PlayerCell

            if visibleCells.contains(tmpCell) {
                print("title = \(allVideo[indexPath.row].title)")
                
                if !tmpCell.playing {
                    tmpCell.playing = true
                    tmpCell.performAutoPlay()
                }
            }
        }
        
    }
}

extension ViewController: ZFPlayerDelegate {
    func zf_playerDownload(_ url: String!) {
    }
    
}

