//
//  UploadManager.swift
//  UploadVideoAndImage
//
//  Created by CallmeOni on 7/9/2566 BE.
//

import Foundation
import Alamofire
import AVFoundation

class URLUpload:NSObject{
    static func urlUpload()->String?{
        return ""
    }
}

class UploadManager:NSObject{
    
    static func uploadVideoToServer(videoTitle: String, videoCaption: String, videoURL: URL?, coverImageData: Data, ssImageData: Data, completionUpload: @escaping (_ jsonReturn:[String:Any]?, _ strError:String?) -> Void) {
        
        //MARK: ServerURL
        guard let serverURL = URLUpload.urlUpload() else{
            print("uploadVideoToServer -> No serverURL")
            return
        }
        
        //MARK: CheckVideo
        guard let videoURLSend = videoURL else{
            print("videoURLSend -> No URL")
            return
        }
        
        var filetypeVideo = ""
        do{
            //MARK: Data Processing
            let videoDataSend = try Data.init(contentsOf: videoURLSend)
            if let fileType = videoURLSend.absoluteString.components(separatedBy: ".").last{
                filetypeVideo = fileType.lowercased()
            }
            
            let strVideoName = String(format: "%@_video_file.%@", UploadManager.getNameFilteUploadVideoOrPhoto(), filetypeVideo.lowercased())
            
            let strCoverImageName = String(format: "%@_cover_img_file.%@", UploadManager.getNameFilteUploadVideoOrPhoto(), "jpg".lowercased())
            
            let strSsImageName = String(format: "%@_ss_img_file.%@", UploadManager.getNameFilteUploadVideoOrPhoto(), "jpg".lowercased())
            
            if filetypeVideo.count > 0{
                //MARK: ส่ง Data
                
                guard let fileExtension = videoURL?.pathExtension else{
                    return
                }
                
                let mimeType: String
                
                switch fileExtension.lowercased() {
                case "mov":
                    mimeType = "video/quicktime"
                case "mp4":
                    mimeType = "video/mp4"
                default:
                    fatalError("Unsupported video format: \(fileExtension)")
                }
                
                let boundary = "---------------------------12378990217398"
                let httpHeader :HTTPHeaders = [String(format: "multipart/form-data; boundary=%@", boundary):"Content-Type"]
                
                AF.upload(multipartFormData: { multipartFormData in
                    
                    //MARK: Add multipartFormData
                    if let videoTitleData = videoTitle.data(using: .utf8){
                        multipartFormData.append(videoTitleData, withName: "video_title")
                    }
                    
                    if let videoCaptionData = videoTitle.data(using: .utf8){
                        multipartFormData.append(videoCaptionData, withName: "video_caption")
                    }
                    
                    multipartFormData.append(videoDataSend, withName: "video_file", fileName: strVideoName, mimeType: mimeType)
                    
                    multipartFormData.append(coverImageData, withName: "cover_img_file", fileName: strCoverImageName, mimeType: "image/jpg")
                    
                    multipartFormData.append(ssImageData, withName: "ss_img_file", fileName: strSsImageName, mimeType: "image/jpg")
                    
                    
                }, to: serverURL, method: .post, headers: httpHeader)
                .uploadProgress { progress in
                    print("Upload Progress: \(progress.fractionCompleted)")
                }
                .response { response in
                    print("response -> \(response)")
                    
                    if let res = response.data{
                        print("response.data -> \(String(data: res, encoding: .utf8))")
                    }
                    
                    if let httpResponse = response.response {
                        print("HTTP Status Code: \(httpResponse.statusCode)")
                    }
                    
                    switch response.result {
                    case .success:
                        // Upload successful
                        print("Upload successful")
                        if let res = response.data{
                            print("response.data -> \(String(data: res, encoding: .utf8))")
                        }
                    case .failure(let error):
                        // Upload failed
                        print("Upload failed error -> \(error.localizedDescription)")
                        completionUpload(nil, error.localizedDescription)
                    }
                }
            }
        }catch{
            print("videoURLDataSend -> try Data videoURLSend Error")
            completionUpload(nil, error.localizedDescription)
        }
    }
    
    static func uploadImageToServer(imgCaption: String, coverImageData: Data, completionUpload: @escaping (_ jsonReturn:[String:Any]?, _ strError:String?) -> Void) {
        
        //MARK: ServerURL
        guard let serverURL = URLUpload.urlUpload() else{
            print("uploadVideoToServer -> No serverURL")
            return
        }
        
        
        var filetypeVideo = ""
        //MARK: Data Processing
        let strCoverImageName = String(format: "%@_cover_img_file.%@", UploadManager.getNameFilteUploadVideoOrPhoto(), "jpg".lowercased())
        
        if filetypeVideo.count > 0{
            //MARK: ส่ง Data
            
            let boundary = "---------------------------12378990217398"
            let httpHeader :HTTPHeaders = [String(format: "multipart/form-data; boundary=%@", boundary):"Content-Type"]
            
            AF.upload(multipartFormData: { multipartFormData in
                //MARK: Add multipartFormData
                if let imgCaptionData = imgCaption.data(using: .utf8){
                    multipartFormData.append(imgCaptionData, withName: "video_caption")
                }
                
                multipartFormData.append(coverImageData, withName: "cover_img_file", fileName: strCoverImageName, mimeType: "image/jpg")
                
            }, to: serverURL, method: .post, headers: httpHeader)
            .uploadProgress { progress in
                print("Upload Progress: \(progress.fractionCompleted)")
            }
            .response { response in
                print("response -> \(response)")
                
                if let res = response.data{
                    print("response.data -> \(String(data: res, encoding: .utf8))")
                }
                
                if let httpResponse = response.response {
                    print("HTTP Status Code: \(httpResponse.statusCode)")
                }
                
                switch response.result {
                case .success:
                    // Upload successful
                    print("Upload successful")
                    if let res = response.data{
                        print("response.data -> \(String(data: res, encoding: .utf8))")
                    }
                case .failure(let error):
                    // Upload failed
                    print("Upload failed error -> \(error.localizedDescription)")
                    completionUpload(nil, error.localizedDescription)
                }
            }
        }
    }
    
    //MARK: pathFolder
    static func pathFolder(nameFile:String) -> String?{
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let localFilePath = documentsDirectory.appendingPathComponent(nameFile).path
            return localFilePath
        }else{
            return nil
        }
    }
    
    //MARK: reverseStringSwift
    static func reverseString(_ input: String) -> String {
        return String(input.reversed())
    }
    
    //MARK: NameVideoOrPhoto
    static func getNameFilteUploadVideoOrPhoto() -> String{
        var serialNumber = ""
        var date = ""
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        formatter.locale = Locale(identifier: "th_TH")
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone(identifier: "ICT")
        date = formatter.string(from: Date())
        serialNumber = String(format: "%@_%@", date, UUID().uuidString)
        return String(format: "ios_%@", serialNumber)
    }
    
    static func generateThumbnailMax1200(videoURL:URL) -> (thumbnailImg:UIImage?, thumbnailData:Data?)?{
        do {
            let asset = AVURLAsset(url: videoURL , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            var thumbnail = UIImage(cgImage: cgImage)
            let maxSize = 1200.00
            var width = thumbnail.size.width
            var height = thumbnail.size.height
            if (thumbnail.size.width > maxSize || thumbnail.size.height > maxSize) {
                if (width>height) {
                    width = maxSize
                    height = (height*width)/thumbnail.size.width
                }else if (width<height) {
                    height = maxSize
                    width = (width*height)/thumbnail.size.height
                }else{
                    width = maxSize
                    height = maxSize
                }
                thumbnail = thumbnail.resized(to: CGSize(width: width, height: height))
            }
            if let imageData = thumbnail.jpegData(compressionQuality: 1.0) {
                return (thumbnail, imageData)
            }else{
                return (thumbnail, nil)
            }
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return (nil, nil)
        }
    }
    
    static func generateThumbnailGeneral(imageChange:UIImage, widthSize:Double, heightSize:Double) -> (thumbnailImg:UIImage?, thumbnailData:Data?)?{
        var thumbnail = imageChange
        thumbnail = thumbnail.resized(to: CGSize(width: widthSize, height: heightSize))
        if let imageData = thumbnail.jpegData(compressionQuality: 1.0) {
            return (thumbnail, imageData)
        }else{
            return (thumbnail, nil)
        }
    }
}

extension UIImage {
    func resized(to targetSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { (context) in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}
