//
//  AssetsExtension.swift
//  YoGIF Staging
//
//  Created by Orphan on 3/27/18.
//  Copyright © 2018 YoGIF. All rights reserved.
//


import AVFoundation

extension AVAsset {
    func writeAudioTrack(to url: URL,
                         success: @escaping (URL) -> (),
                         failure: @escaping (Error) -> ()) {
        do {
            let asset = try audioAsset()
            asset.write(to: url, success: success, failure: failure)
        } catch {
            failure(error)
        }
    }
    
    private func write(to url: URL,
                       success: @escaping (URL) -> (),
                       failure: @escaping (Error) -> ()) {
        
        guard let exportSession = AVAssetExportSession(asset: self,
                                                       presetName: AVAssetExportPresetAppleM4A) else {
                                                        
                                                        let error = NSError(domain: "domain",
                                                                            code: 0,
                                                                            userInfo: nil)
                                                        failure(error)
                                                        
                                                        return
        }
        
        exportSession.outputFileType = AVFileType.m4a
        exportSession.outputURL = url
        
        exportSession.exportAsynchronously {
            switch exportSession.status {
            case .completed:
                success(url)
            case .unknown, .waiting, .exporting, .failed, .cancelled:
                let error = NSError(domain: "domain", code: 0, userInfo: nil)
                failure(error)
            }
        }
    }
    
    private func audioAsset() throws -> AVAsset {
        let composition = AVMutableComposition()

        let audioTracks = tracks(withMediaType: .audio)
        var audioTrack: AVAssetTrack?
        if !audioTracks.isEmpty {
            audioTrack = audioTracks[0]
        }

        
        if let aTrack = audioTrack {
            let compositionTrack = composition.addMutableTrack(withMediaType: .audio,
                                                               preferredTrackID: kCMPersistentTrackID_Invalid)
            do {
                try compositionTrack?.insertTimeRange(aTrack.timeRange,
                                                      of: aTrack,
                                                      at: aTrack.timeRange.start)
            } catch {
                throw error
            }
        }
        
        
        return composition
    }
}
