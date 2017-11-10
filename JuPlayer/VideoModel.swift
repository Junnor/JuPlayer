//
//  VideoModel.swift
//  JuPlayer
//
//  Created by nyato on 2017/11/10.
//  Copyright © 2017年 moelove. All rights reserved.
//

import Foundation

class VideoModel {
    
    var title = ""
    var videoDescription = ""
    var playUrl = ""
    var coverForFeed = ""
    
    var playInfo: [VideoResolution] = []
}

class VideoResolution {
    
    var name = ""
    var type = ""
    var url = ""
    
    var height = 0
    var width = 0
}
