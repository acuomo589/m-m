import Foundation
import RealmSwift

class Session {
    

    
    func sessionRequest(data: NSDictionary, to: String, method: String,
                        completionHandler: @escaping (NSDictionary?, Error?) -> Void) -> URLSessionDataTask {

        let url = URL(string: "\(AppConstants.api)/\(to)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)

        print(url!)
        var request = URLRequest(url:url!)

        request.httpMethod = method

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(AppConstants.apiXAPIKey, forHTTPHeaderField: "x-api-key")

        if let token = User.getToken() {
            request.addValue("\(token)",forHTTPHeaderField: "Authorization")
        }
        if data != [:] {
            request.httpBody = try! JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        }

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            print(data)
//            print(response)
//            print(error)
            if let error = error {
                if error.localizedDescription == "cancelled" {
                    //                if String(describing: error) == "cancelled" {
                    print("cancelled request")
                } else {
                    print("error=\(String(describing: error))")
                    OperationQueue.main.addOperation {
                        completionHandler(nil, error)
                    }
                }

            } else {
                do {
                    // response has correct JSON
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    OperationQueue.main.addOperation {
                        completionHandler(result, nil)
                    }
                } catch {
                    // Failed to parse JSON, checking reposne code. Fine if 200-299
                    if let httpResponse = response as? HTTPURLResponse {
                        print(httpResponse)
                        print(httpResponse.statusCode)
                        if httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 {
                            OperationQueue.main.addOperation {
                                completionHandler([:], nil)
                            }
                        } else {
                            OperationQueue.main.addOperation {
                                completionHandler(["statusCode": httpResponse.statusCode], error)
                            }
                        }
                    } else {
                        print(error)
                        OperationQueue.main.addOperation {
                            completionHandler(nil, error)
                        }
                    }
                }
            }
        }
        task.resume()

        return task
    }
    
    func sessionPushNotificationRequest(data: NSDictionary, to: String, method: String,
                        completionHandler: @escaping (NSDictionary?, Error?) -> Void) -> URLSessionDataTask {
        
        let url = URL(string: "\(AppConstants.pushApi)/\(to)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        
        print(url!)
        var request = URLRequest(url:url!)
        
        request.httpMethod = method
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(AppConstants.pushXAPIKey, forHTTPHeaderField: "x-api-key")
        
        if let token = User.getToken() {
            request.addValue("\(token)",forHTTPHeaderField: "Authorization")
        }
        if data != [:] {
            request.httpBody = try! JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            //            print(data)
            //            print(response)
            //            print(error)
            if let error = error {
                if error.localizedDescription == "cancelled" {
                    //                if String(describing: error) == "cancelled" {
                    print("cancelled request")
                } else {
                    print("error=\(String(describing: error))")
                    OperationQueue.main.addOperation {
                        completionHandler(nil, error)
                    }
                }
                
            } else {
                do {
                    // response has correct JSON
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    OperationQueue.main.addOperation {
                        completionHandler(result, nil)
                    }
                } catch {
                    // Failed to parse JSON, checking reposne code. Fine if 200-299
                    if let httpResponse = response as? HTTPURLResponse {
                        print(httpResponse)
                        print(httpResponse.statusCode)
                        if httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 {
                            OperationQueue.main.addOperation {
                                completionHandler([:], nil)
                            }
                        } else {
                            OperationQueue.main.addOperation {
                                completionHandler(["statusCode": httpResponse.statusCode], error)
                            }
                        }
                    } else {
                        print(error)
                        OperationQueue.main.addOperation {
                            completionHandler(nil, error)
                        }
                    }
                }
            }
        }
        task.resume()
        
        return task
    }

    func imageUpload(data: [String: Any], image: UIImage, objectName: String, imageName: String, to: String, completionHandler: @escaping (NSDictionary?, Error?) -> Void) -> Void{

        let url = URL(string: "\(AppConstants.api)/\(to)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)

        print(url!)
        var request = URLRequest(url:url!)

        request.httpMethod = "POST"

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        if let token = User.getToken() {
            request.addValue("Token \(token)",forHTTPHeaderField: "Authorization")
        }

        request.httpBody = createBody(parameters: data,
                boundary: boundary,
                objectName: objectName,
                imageName: imageName,
                data: UIImageJPEGRepresentation(image, 0.7)!,
                mimeType: "image/jpg",
                filename: "photo.jpg")

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("error=\(String(describing: error))")
                OperationQueue.main.addOperation {
                    completionHandler(nil, error);
                }
            } else {
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    OperationQueue.main.addOperation {
                        completionHandler(result, nil)
                    }
                } catch {
                    print(error)
                    OperationQueue.main.addOperation {
                        completionHandler(nil, error)
                    }
                }

            }        }
        task.resume()
    }

    func createBody(parameters: [String: Any],
                    boundary: String,
                    objectName: String,
                    imageName: String,
                    data: Data,
                    mimeType: String,
                    filename: String) -> Data {
        let body = NSMutableData()

        let boundaryPrefix = "--\(boundary)\r\n"

        for (key, value) in parameters {
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"\(objectName)[\(key)]\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }

        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; " +
                "name=\"\(objectName)[\(imageName)]\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--")))

        return body as Data
    }
}

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
