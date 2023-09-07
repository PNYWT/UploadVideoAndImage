//
//  ViewController.swift
//  UploadVideoAndImage
//
//  Created by CallmeOni on 7/9/2566 BE.
//

import UIKit
import YPImagePicker
import AVFoundation

class ViewController: UIViewController {

    private var config = YPImagePickerConfiguration()
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var imgThumbnail: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnSelect.addTarget(self, action: #selector(actionShowLibrary), for: .touchUpInside)
        setupYPIConfig()
    }
    
    private func setupYPIConfig(){
        config.library.options = nil
        config.library.onlySquare = false
        config.library.isSquareByDefault = true
        config.library.minWidthForItem = nil
        config.library.mediaType = .photo
        config.library.defaultMultipleSelection = false
        config.library.maxNumberOfItems = 1
        config.library.minNumberOfItems = 1
        config.library.numberOfItemsInRow = 4
        config.library.spacingBetweenItems = 1.0
        config.library.skipSelectionsGallery = false
        config.library.preselectedItems = nil
        config.library.preSelectItemOnMultipleSelection = true
    }

    @objc func actionShowLibrary(){
        let picker = YPImagePicker(configuration: self.config)
        
        picker.didFinishPicking { items, cancelled in
            if let img = items.singlePhoto {
                self.imgThumbnail.image = img.image
                self.imgThumbnail.contentMode = .scaleAspectFit
                
                guard let imgData = img.image.jpegData(compressionQuality: 1.0)else{
                    return
                }
                
                UploadManager.uploadImageToServer(imgCaption: "Hello world", coverImageData: imgData) { jsonReturn, strError in
                    let alert = UIAlertController(title: nil, message: "Upload Success", preferredStyle: .alert)
                    alert.addAction(UIAlertAction.init(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }

}

