//
//  PhotoSelectionUtility.m
//
//  Created by Matthew Sabath
//  MIT License

#import "PhotoSelectionUtility.h"

#import <Photos/Photos.h>

@interface PhotoSelectionUtility () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, assign) UIViewController *viewController;
@end


@implementation PhotoSelectionUtility

#pragma mark - Post Photo

- (void)submitUserPhotoFromViewController:(UIViewController *)vc
{
    self.viewController = vc;
    
    if ([self systemVersionGreaterThanOrEqual:@"8.0"])
    {
        if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
            [self getUserImagePhoto];
        }
        else if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {
            [self requestPhotoPermissions];
        }
        else if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusDenied) {
            [self showPhotosDeniedAlert];
        }
    } else {
        // basic handling for iOS versions prior to iOS8
        [self getUserImagePhoto];
    }
}

- (void)getUserImagePhoto
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] &&
        [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear])
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@"Submit Photo"
                                      delegate:self
                                      cancelButtonTitle:@"Cancel"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"Choose From Library",@"Take New Photo", nil];
        
        if (self.viewController.presentedViewController) {
            [actionSheet showInView:self.viewController.presentedViewController.view];
        } else {
            [actionSheet showInView:self.viewController.navigationController.view];
        }
        
    } else {
        [self choosePhotoFromLibrary];
    }
}

- (void)choosePhotoFromLibrary
{
    if (self.imagePickerController == nil) {
        self.imagePickerController = [[UIImagePickerController alloc] init];
    }
    
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePickerController.delegate = self;
    [self presentImagePickerController:self.imagePickerController];
}

- (void)takeNewPhoto
{
    if (self.imagePickerController == nil) {
        self.imagePickerController = [[UIImagePickerController alloc] init];
    }
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePickerController.delegate = self;
    [self presentImagePickerController:self.imagePickerController];
}

- (void)presentImagePickerController:(UIViewController *)pickerController
{
    if (self.viewController.presentedViewController) {
        [self.viewController.presentedViewController presentViewController:pickerController animated:YES completion:^{}];
    } else {
        [self.viewController.navigationController presentViewController:pickerController animated:YES completion:^{}];
    }
}

- (void)requestPhotoPermissions {
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        switch (status) {
            case PHAuthorizationStatusAuthorized:
                [self getUserImagePhoto];
                break;
            case PHAuthorizationStatusRestricted:
                break;
            case PHAuthorizationStatusDenied:
                break;
            default:
                break;
        }
    }];
}

- (void)showPhotosDeniedAlert
{
    [[[UIAlertView alloc] initWithTitle:@"Photo Access Denied"
                                message:@"Please go to the Settings app from your device's home screen to re-enable photos."
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}


#pragma mark - ImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    picker.delegate = self;
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        [self.delegate photoSelectionUtilityDidReturnImage:image];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{ }];
}


#pragma mark - Image Manipulation

- (UIImage *)normalizedImage:(UIImage *)image
{
    if (image.imageOrientation == UIImageOrientationUp) return image;
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    [image drawInRect:(CGRect){0, 0, image.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}


#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self choosePhotoFromLibrary];
    } else if (buttonIndex == 1) {
        [self performSelectorOnMainThread:@selector(takeNewPhoto) withObject:nil waitUntilDone:NO];
    }
}


#pragma mark - Utility

- (BOOL)systemVersionGreaterThanOrEqual:(NSString *)systemVersion {
    return ([[[UIDevice currentDevice] systemVersion] compare:systemVersion options:NSNumericSearch] != NSOrderedAscending);
}

@end
