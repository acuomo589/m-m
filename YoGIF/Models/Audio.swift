//
// Created by Kyrylo Savytskyi on 10/9/17.
// Copyright (c) 2017 YoGIF. All rights reserved.
//

import UIKit

class Audio {
    static func listAudio(completionHandler: @escaping ([String]?, String?) -> Void) {
        _ = Session().sessionRequest(data: [:] as NSDictionary,
                                     to: "listAudio",
                                     method: "GET", completionHandler: {(result, error) in
                                        if let audios = result?["presets"] as? [String] {
                                            completionHandler(audios, nil)
                                        } else if let error = error {
                                            completionHandler(nil, error.localizedDescription)
                                        } else {
                                            completionHandler(nil, "Unexpected error")
                                        }
        })
    }

    static func uploadAudio(_ audioUrl: URL, isPublic: Bool, completionHandler: @escaping (String?, String?) -> Void) {
        if let username = User.myUsername() {
            let fu = FileUploader()
            fu.uploadFile(filePath: audioUrl, type: "audio", username: username) { url, task in
                if let url = url {
                    let uid = UUID().uuidString
                    let json = [
                        "uid": uid,
                        "permission": isPublic ? "shared" : "private"
                    ]
                    _ = Session().sessionRequest(data: json as NSDictionary,
                                                 to: "uploadAudio",
                                                 method: "POST", completionHandler: {(result, error) in
                                                    if let result = result {
                                                        //                                                        let visualData = [
                                                        //                                                            "filename": "uid",
                                                        //                                                            "permission": isPublic ? "shared" : "private",
                                                        //                                                            "username": username
                                                        //                                                        ]

                                                        completionHandler(uid, nil)
                                                    } else if let error = error {
                                                        completionHandler(nil, error.localizedDescription)
                                                    } else {
                                                        completionHandler(nil, "Unexpected error")
                                                    }
                    })
                } else {
                    completionHandler(nil, "Unexpected error")
                }
            }

        }
    }

    static func updateAudio(_ audioUrl: URL, isPublic: Bool, completionHandler: @escaping (String?, String?) -> Void) {
        //it is basically just a copy of uploadAudio. Do we need it?
        if let username = User.myUsername() {
            let fu = FileUploader()
            fu.uploadFile(filePath: audioUrl, type: "audio", username: username) { url, task in
                if let url = url {
                    let uid = UUID().uuidString
                    let json = [
                        "uid": uid,
                        "permission": isPublic ? "shared" : "private"
                    ]
                    _ = Session().sessionRequest(data: json as NSDictionary,
                                                 to: "uploadAudio",
                                                 method: "POST", completionHandler: {(result, error) in
                                                    print(result)
                                                    print(error)
                                                    if let result = result {
                                                        //                                                        let visualData = [
                                                        //                                                            "filename": "uid",
                                                        //                                                            "permission": isPublic ? "shared" : "private",
                                                        //                                                            "username": username
                                                        //                                                        ]

                                                        completionHandler(uid, nil)
                                                    } else if let error = error {
                                                        completionHandler(nil, error.localizedDescription)
                                                    } else {
                                                        completionHandler(nil, "Unexpected error")
                                                    }
                    })
                } else {
                    completionHandler(nil, "Unexpected error")
                }
            }

        }
    }

    static func getInfo(completionHandler: @escaping (String?, String?) -> Void) {
        //        if let username = self.username {
        //            _ = Session().sessionRequest(data: [:] as NSDictionary,
        //                    to: "getAudio?owner=\(username)&uid=\(self.filename)",
        //                    method: "GET", completionHandler: {(result, error) in
        //                print(result)
        //                print(error)
        //                if let result = result {
        //                    let visualObject = Visual.toRealm(data: result as NSDictionary)
        //                    completionHandler(visualObject, nil)
        //                } else if let error = error {
        //                    completionHandler(nil, error.localizedDescription)
        //                } else {
        //                    completionHandler(nil, "Unexpected error")
        //                }
        //            })
        //        }
        
    }
}
