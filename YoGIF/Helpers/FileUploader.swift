//
//  FileUploader.swift
//  ProNear
//
//  Created by Alex on 7/25/17.
//  Copyright © 2017 ProNeat. All rights reserved.
//

import Foundation
import AWSS3

class FileUploader {
    
    func uploadImage(image: UIImage, username: String, completion:@escaping (String? , AWSTask<AnyObject>? ) -> ()) {
        // save image to file system, get its name and path:
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]

        if let data = UIImageJPEGRepresentation(image, 0.8) {
            let imageName = NSUUID().uuidString.lowercased() + ".jpg"
            let fileName = documentsDirectory.appendingPathComponent(imageName)
            try? data.write(to: fileName)
            uploadFile(filePath: fileName, type: "photo", username: username, completion: completion)
        }
    }

    func uploadFile(filePath: URL, type: String, username: String, completion:@escaping (String?, AWSTask<AnyObject>?) -> ()) {
        if let accessKey = UserDefaults.standard.string(forKey: AppConstants.nsudS3AccessKeyId),
            let secretKey = UserDefaults.standard.string(forKey: AppConstants.nsudS3SecretAccessKey),
            let sessionToken = UserDefaults.standard.string(forKey: AppConstants.nsudS3SessionToken) {

            let credentialsProvider = AWSBasicSessionCredentialsProvider(
                accessKey: accessKey,
                secretKey: secretKey,
                sessionToken: sessionToken)
            if let configuration = AWSServiceConfiguration(
                region: AppConstants.cognitoPoolRegion,
                credentialsProvider: credentialsProvider) {
                configuration.timeoutIntervalForRequest = 5*60
                AWSServiceManager.default().defaultServiceConfiguration = configuration
            }


            _ = NSUUID().uuidString.lowercased()
            _ = filePath.pathExtension
            let remoteFilePath: String

            //        if type == "photo" {
            //            remoteFilePath = "photo/\(remoteFileName).\(fileExtension)" as NSString
            //        } else if type == "video" {
            //            remoteFilePath = "video/\(remoteFileName).\(fileExtension)" as NSString
            //        } else {
            //            remoteFilePath = "misc/\(remoteFileName).\(fileExtension)" as NSString
            //        }
            if type == "video" {
                remoteFilePath = "user/\(username)/upload/upload1.mp4"
            } else if type == "audio" {
                remoteFilePath = "user/\(username)/upload/upload1.m4a"
            } else if type == "profile_pic" {
                remoteFilePath = "user/\(username)/profile.png"
            } else {
                remoteFilePath = "user/\(username)/upload/upload1"
            }

            let bucket = AppConstants.s3BucketName//"yogif-us-west-2-bucket1"

            let transferManager = AWSS3TransferManager.default()
            if let uploadRequest = AWSS3TransferManagerUploadRequest() {
                uploadRequest.bucket = bucket
                uploadRequest.key = remoteFilePath as String
                uploadRequest.body = filePath
                uploadRequest.acl = AWSS3ObjectCannedACL.publicRead
                transferManager.upload(uploadRequest).continueWith(block: { (task: AWSTask<AnyObject>) -> Any? in
                    // make sure we are on the main thread
                    OperationQueue.main.addOperation({
                        //                    print(task.result)
                        //                    print(task.error)
                        //                    print(task.isCancelled)
                        //                    print(task.isFaulted)
                        //                    print(task.isCompleted)
                        let taskCompleted = task.result != nil &&
                            task.error == nil &&
                            task.isCancelled == false &&
                            task.isFaulted == false &&
                            task.isCompleted == true
                        if taskCompleted {
                            completion("https://\(bucket).s3.amazonaws.com/\(remoteFilePath)", nil)
                        } else {
                            if let error = task.error as NSError? {
                                if error.domain == AWSS3TransferManagerErrorDomain,
                                    let code = AWSS3TransferManagerErrorType(rawValue: error.code) {
                                    switch code {
                                    case .cancelled, .paused:
                                        break
                                    default:
                                        print("Error downloading: \(String(describing: uploadRequest.key)) Error: \(error)")
                                        completion(nil, task)
                                    }
                                } else {
                                    print("Error downloading: \(String(describing: uploadRequest.key)) Error: \(error)")
                                    completion(nil, task)
                                }
                            }
                            completion(nil, task)
                        }
                    })
                    return true
                })
            }
        }
    }
}
