//
//  GeneralMethods.swift
//  YoGIF Staging
//
//  Created by Orphan on 4/12/18.
//  Copyright © 2018 YoGIF. All rights reserved.
//

import UIKit
import QuartzCore
import AsyncDisplayKit

class GeneralMethods: NSObject {

    static func loadImage(visual: Visual, username: String, callback: @escaping ((_ image: UIImage) -> Void)) {
        let filename = visual.filename
        if let file = visual.file() {
            let asset = AVURLAsset(url: file, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            if let cgImage = try? imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil) {
                callback(UIImage(cgImage: cgImage))
            } else {
                
            }
        } else {
            let fd = FileDownloader()
            fd.downloadAwsVideo(username: username, filename: filename, isPublic: visual.isPublic) { error in
                if let error = error {
                    print(error)
                } else {
                    self.loadImage(visual: visual, username: username, callback: { image in
                        callback(image)
                    })
                }
            }
        }
    }
    
    static func playAudio(player: AVAudioPlayer?) {
        if let audioPlayer = player, audioPlayer.isPlaying == false {
            audioPlayer.play()
        }
    }
    
}
