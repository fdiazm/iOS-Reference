//
//  ViewController.swift
//  ImageResize
//
//  Created by Felipe Díaz on 02/02/17.
//  Copyright © 2017 FDM. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    //MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        self.imgView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionImagen(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        self.present(imagePicker, animated: true, completion: nil);
    }
    
    @IBAction func actionGuardar(_ sender: Any) {
        let originalImageSize = self.imgView.image?.size
        
        if let validSize = originalImageSize
        {
            let newSize:CGSize = CGSize(width: validSize.width / 4, height: validSize.height / 4)
            let newImage = resizeImage(image: self.imgView.image!, targetSize: newSize)
            
            let newFilePath = NSTemporaryDirectory() + "Temporal2.png";
            let newURL = URL(fileURLWithPath: newFilePath)
            
            let imageDataToWrite = UIImagePNGRepresentation(newImage)
            
            try? imageDataToWrite?.write(to: newURL)
            print(newFilePath)
        }
    }
}

