//
//  PhotoSelectionUtility.swift
//  DemoPhotoSelectionUtility_Swift
//
//  Created by Matthew Sabath on 11/10/15.
//  MIT License
//

import Foundation


import Foundation
import Photos
import UIKit

protocol PhotoSelectionUtilityDelegate: class {
    func photoSelectionUtilityDidReturnImage(image: UIImage)
}

class PhotoSelectionUtility: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    weak var delegate: PhotoSelectionUtilityDelegate?
    
    var imagePickerController: UIImagePickerController?
    var viewController: UIViewController?
    
    override init() {
        super.init()
        
    }
    
    func submitUserPhotoFromViewController(vc: UIViewController) {
        
        self.viewController = vc;
        
        if (systemVersionGreaterThanOrEqualToiOS8()) {
            
            let authStatus = PHPhotoLibrary.authorizationStatus()
            
            if (authStatus == .Authorized) {
                getUserImagePhoto()
            } else if (authStatus == .NotDetermined) {
                requestPhotoPermissions()
            } else if (authStatus == .Denied) {
                
            }
        }
    }
    
    func getUserImagePhoto() {
        
        if (UIImagePickerController.isSourceTypeAvailable(.Camera)) {
            let alertController = UIAlertController(title: "Submit Photo", message: nil, preferredStyle: .ActionSheet)
            
            let libraryAction = UIAlertAction(title: "Choose From Library", style: .Default, handler: { _ in
                self.choosePhotoFromLibrary()
            })
            
            let cameraAction = UIAlertAction(title: "Take New Photo", style: .Default, handler: { _ in
                self.takeNewPhoto()
            })
            
            alertController.addAction(libraryAction)
            alertController.addAction(cameraAction)
            
            if let presentedVC = viewController!.presentedViewController {
                presentedVC.presentViewController(alertController, animated: true, completion: nil)
            } else {
                viewController!.presentViewController(alertController, animated: true, completion: nil)
            }
            
        } else {
            choosePhotoFromLibrary()
        }
    }
    
    func takeNewPhoto() {
        imagePickerController = UIImagePickerController()
        imagePickerController!.sourceType = .Camera
        imagePickerController!.delegate = self
        
        presentImagePickerController(imagePickerController!)
    }
    
    func choosePhotoFromLibrary() {
        imagePickerController = UIImagePickerController()
        imagePickerController!.sourceType = .PhotoLibrary
        imagePickerController!.delegate = self
        
        presentImagePickerController(imagePickerController!)
    }
    
    func presentImagePickerController(pickerController: UIViewController) {
        if let _ = viewController!.presentedViewController {
            viewController!.presentedViewController!.presentViewController(pickerController, animated: true, completion:nil)
        } else {
            viewController!.navigationController?.presentViewController(pickerController, animated: true, completion:nil)
        }
    }
    
    func requestPhotoPermissions() {
        PHPhotoLibrary.requestAuthorization { (status) -> Void in
            
            switch (status) {
            case .Authorized:
                self.getUserImagePhoto()
                break;
                
            case .Restricted:
                // handle
                break;
                
            case .Denied:
                // handle
                break;
                
            default:
                break;
            }
        }
    }
    
    
    // MARK: ImagePickerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        picker.delegate = self;
        picker.dismissViewControllerAnimated(true, completion: { _ in
            
            self.delegate?.photoSelectionUtilityDidReturnImage(image)
        })
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Alerts
    
    func throwPhotosDeniedAlert() {
        let alertController = UIAlertController(title: "Photo Access Denied", message: "Please go to the Settings app from your device's home screen to re-enable photos.", preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: { _ in
            self.viewController!.dismissViewControllerAnimated(true, completion: nil)
        })
        
        alertController.addAction(okAction)
        viewController!.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: Utility
    
    func systemVersionGreaterThanOrEqualToiOS8() -> Bool {
        return NSProcessInfo().isOperatingSystemAtLeastVersion(NSOperatingSystemVersion(majorVersion: 8, minorVersion: 0, patchVersion: 0))
    }
}