import Foundation
import UIKit
import AWSS3

class FileDownloader {

    func downloadJSONFile( _ completion:@escaping (String?) -> ()) {
        if let accessKey = UserDefaults.standard.string(forKey: AppConstants.nsudS3AccessKeyId),
            let secretKey = UserDefaults.standard.string(forKey: AppConstants.nsudS3SecretAccessKey),
            let sessionToken = UserDefaults.standard.string(forKey: AppConstants.nsudS3SessionToken) {

            let credentialsProvider = AWSBasicSessionCredentialsProvider(
                accessKey: accessKey,
                secretKey: secretKey,
                sessionToken: sessionToken)
            let configuration = AWSServiceConfiguration(
                region: AppConstants.cognitoPoolRegion,
                credentialsProvider: credentialsProvider)
            AWSServiceManager.default().defaultServiceConfiguration = configuration

            let transferManager = AWSS3TransferManager.default()
            let downloadingFileURL = URL(fileURLWithPath: NSTemporaryDirectory())
                .appendingPathComponent("weekly-config.json")

            if let downloadRequest = AWSS3TransferManagerDownloadRequest() {
                downloadRequest.bucket = AppConstants.s3BucketName//"yogif-us-west-2-bucket1"
                downloadRequest.key = "weekly-config.json"
                downloadRequest.downloadingFileURL = downloadingFileURL
                transferManager.download(downloadRequest)
                    .continueWith(executor: AWSExecutor.mainThread(), block: { (task: AWSTask<AnyObject>) -> Any? in
                        if let error = task.error as NSError? {
                            if error.domain == AWSS3TransferManagerErrorDomain,
                                let code = AWSS3TransferManagerErrorType(rawValue: error.code) {
                                switch code {
                                case .cancelled, .paused:
                                    break
                                default:
                                    print("Error downloading: \(String(describing: downloadRequest.key)) Error: \(error)")
                                    completion(error.localizedDescription)
                                }
                            } else {
                                print("Error downloading: \(String(describing: downloadRequest.key)) Error: \(error)")
                                completion(error.localizedDescription)
                            }
                            return nil
                        }
                        print("Download complete for: \(String(describing: downloadRequest.key))")
                        _ = task.result as? Data
                        //                    self.loadImage(visual: visual, username: username)
                        completion(nil)
                        return nil
                    })

            }

        }
    }
    
    

    func downloadImage(url: URL, completion:@escaping (UIImage?, String? ) -> ()) {

        let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfiguration)

        let request = NSMutableURLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 60)
        request.httpShouldHandleCookies = false
        request.httpMethod = "GET"

        let cachedResponse = URLCache.shared.cachedResponse(for: request as URLRequest)

        if let data = cachedResponse?.data {
            let image = UIImage(data: data)
            completion(image, nil)
        } else {
            session.dataTask(with: request as URLRequest, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                DispatchQueue.main.async() { () -> Void in
                    if let data = data {
                        let image = UIImage(data: data)
                        completion(image, nil)
                    } else if let error = error?.localizedDescription {
                        NSLog("Failed to download image")
                        completion(nil, error)
                    } else {
                        completion(nil, "Unexpected error")
                    }
                }
            }).resume()
        }
    }

    func downloadVideo(url: URL, completion:@escaping (Data?, String? ) -> ()) {

        let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfiguration)

        let request = NSMutableURLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 60)
        request.httpShouldHandleCookies = false
        request.httpMethod = "GET"

        let cachedResponse = URLCache.shared.cachedResponse(for: request as URLRequest)

        if let data = cachedResponse?.data {
            completion(data, nil)
        } else {
            session.dataTask(with: request as URLRequest, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                DispatchQueue.main.async() { () -> Void in
                    if let data = data {
                        completion(data, nil)
                    } else if let error = error?.localizedDescription {
                        NSLog("Failed to download image")
                        completion(nil, error)
                    } else {
                        completion(nil, "Unexpected error")
                    }
                }
            }).resume()
        }
    }

    func downloadAwsVideo(username: String, filename: String, isPublic: Bool = true, completion:@escaping (String? ) -> ()) {
        if let accessKey = UserDefaults.standard.string(forKey: AppConstants.nsudS3AccessKeyId),
           let secretKey = UserDefaults.standard.string(forKey: AppConstants.nsudS3SecretAccessKey),
           let sessionToken = UserDefaults.standard.string(forKey: AppConstants.nsudS3SessionToken) {

            let credentialsProvider = AWSBasicSessionCredentialsProvider(
                    accessKey: accessKey,
                    secretKey: secretKey,
                    sessionToken: sessionToken)
            let configuration = AWSServiceConfiguration(
                    region: AppConstants.cognitoPoolRegion,
                    credentialsProvider: credentialsProvider)
            AWSServiceManager.default().defaultServiceConfiguration = configuration

            let transferManager = AWSS3TransferManager.default()
            let downloadingFileURL = URL(fileURLWithPath: NSTemporaryDirectory())
                    .appendingPathComponent(filename + ".mp4")

            if let downloadRequest = AWSS3TransferManagerDownloadRequest() {
                downloadRequest.bucket = AppConstants.s3BucketName //"yogif-us-west-2-bucket1"
                let folderName = isPublic ? "shared" : "private"
                downloadRequest.key = "user/" + username + "/\(folderName)/visual/" + filename + ".mp4";
                downloadRequest.downloadingFileURL = downloadingFileURL
                transferManager.download(downloadRequest)
                        .continueWith(executor: AWSExecutor.mainThread(), block: { (task: AWSTask<AnyObject>) -> Any? in
                            if let error = task.error as NSError? {
                        if error.domain == AWSS3TransferManagerErrorDomain,
                           let code = AWSS3TransferManagerErrorType(rawValue: error.code) {
                            switch code {
                            case .cancelled, .paused:
                                break
                            default:
                                print("Error downloading: \(String(describing: downloadRequest.key)) Error: \(error)")
                                completion(error.localizedDescription)
                            }
                        } else {
                            print("Error downloading: \(String(describing: downloadRequest.key)) Error: \(error)")
                            completion(error.localizedDescription)
                        }
                        return nil
                    }
                            print("Download complete for: \(String(describing: downloadRequest.key))")
                            _ = task.result
//                    self.loadImage(visual: visual, username: username)
                        completion(nil)
                    return nil
                })

            }

        }
    }

    func downloadAwsAudio(username: String, filename: String, isPublic: Bool = true, completion:@escaping (String? ) -> ()) {
        if let accessKey = UserDefaults.standard.string(forKey: AppConstants.nsudS3AccessKeyId),
           let secretKey = UserDefaults.standard.string(forKey: AppConstants.nsudS3SecretAccessKey),
           let sessionToken = UserDefaults.standard.string(forKey: AppConstants.nsudS3SessionToken) {

            let credentialsProvider = AWSBasicSessionCredentialsProvider(
                    accessKey: accessKey,
                    secretKey: secretKey,
                    sessionToken: sessionToken)
            let configuration = AWSServiceConfiguration(
                    region: AppConstants.cognitoPoolRegion,
                    credentialsProvider: credentialsProvider)
            AWSServiceManager.default().defaultServiceConfiguration = configuration

            let transferManager = AWSS3TransferManager.default()
            let downloadingFileURL = URL(fileURLWithPath: NSTemporaryDirectory())
                    .appendingPathComponent(filename + ".m4a")

            if let downloadRequest = AWSS3TransferManagerDownloadRequest() {
                downloadRequest.bucket = AppConstants.s3BucketName//"yogif-us-west-2-bucket1"
                let folderName = isPublic ? "shared" : "private"
                downloadRequest.key = "user/" + username + "/\(folderName)/audio/" + filename + ".m4a";
                downloadRequest.downloadingFileURL = downloadingFileURL
                transferManager.download(downloadRequest)
                        .continueWith(executor: AWSExecutor.mainThread(), block: { (task: AWSTask<AnyObject>) -> Any? in
                            if let error = task.error as NSError? {
                                if error.domain == AWSS3TransferManagerErrorDomain,
                                   let code = AWSS3TransferManagerErrorType(rawValue: error.code) {
                                    switch code {
                                    case .cancelled, .paused:
                                        break
                                    default:
                                        print("Error downloading: \(String(describing: downloadRequest.key)) Error: \(error)")
                                        completion(error.localizedDescription)
                                    }
                                } else {
                                    print("Error downloading: \(String(describing: downloadRequest.key)) Error: \(error)")
                                    completion(error.localizedDescription)
                                }
                                return nil
                            }
                            print("Download complete for: \(String(describing: downloadRequest.key))")
                            _ = task.result
//                    self.loadImage(visual: visual, username: username)
                            completion(nil)
                            return nil
                        })

            }

        }
    }

    func downloadAwsImage(username: String, completion:@escaping (String? ) -> ()) {
        if let accessKey = UserDefaults.standard.string(forKey: AppConstants.nsudS3AccessKeyId),
            let secretKey = UserDefaults.standard.string(forKey: AppConstants.nsudS3SecretAccessKey),
            let sessionToken = UserDefaults.standard.string(forKey: AppConstants.nsudS3SessionToken) {

            let credentialsProvider = AWSBasicSessionCredentialsProvider(
                accessKey: accessKey,
                secretKey: secretKey,
                sessionToken: sessionToken)
            let configuration = AWSServiceConfiguration(
                region: AppConstants.cognitoPoolRegion,
                credentialsProvider: credentialsProvider)
            AWSServiceManager.default().defaultServiceConfiguration = configuration

            let transferManager = AWSS3TransferManager.default()
            let downloadingFileURL = URL(fileURLWithPath: NSTemporaryDirectory())
                .appendingPathComponent(username + ".png")

            if let downloadRequest = AWSS3TransferManagerDownloadRequest() {
                downloadRequest.bucket = AppConstants.s3BucketName//"yogif-us-west-2-bucket1"
                downloadRequest.key = User.profilePuctureFor(username);
                downloadRequest.downloadingFileURL = downloadingFileURL
                transferManager.download(downloadRequest)
                    .continueWith(executor: AWSExecutor.mainThread(), block: { (task: AWSTask<AnyObject>) -> Any? in
                        if let error = task.error as NSError? {
                            if error.domain == AWSS3TransferManagerErrorDomain,
                                let code = AWSS3TransferManagerErrorType(rawValue: error.code) {
                                switch code {
                                case .cancelled, .paused:
                                    break
                                default:
                                    print("Error downloading: \(String(describing: downloadRequest.key)) Error: \(error)")
                                    completion(error.localizedDescription)
                                }
                            } else {
                                print("Error downloading: \(String(describing: downloadRequest.key)) Error: \(error)")
                                completion(error.localizedDescription)
                            }
                            return nil
                        }
                        print("Download complete for: \(String(describing: downloadRequest.key))")
                        _ = task.result
                        //                    self.loadImage(visual: visual, username: username)
                        completion(nil)
                        return nil
                    })

            }

        }
    }
}
