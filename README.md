# PhotoSelectionUtility
A utility library to help abstract photo selection logic (UIImagePickerController) 

## Usage

Use PhotoSelectionUtility as a drop in library when having to deal with users taking images from their camera, or selecting images from their Photos.App. 

Make sure the ViewController where you are using PhotoSelectionUtility conforms to the `PhotoSelectionUtilityDelegate` protocol.

## Objective-c

To start the photo selection flow, just call: 

`- (void)submitUserPhotoFromViewController:(UIViewController *)vc` on the `PhotoSelectionUtility` object.

For example, say you have an add photo button for a user's profile, inside the IBAction:

```
- (IBAction)tappedAddImageButton:(id)sender
{
    [self.photoSelectionUtility submitUserPhotoFromViewController:self];
}
```

After a user selects a photo from UIImagePicker, or takes a photo using the camera, this delegate method gets fired:

`- (void)photoSelectionUtilityDidReturnImage:(UIImage *)image;`

which will return to you the image!


## Swift


```
@IBAction func addImageTapped(sender: AnyObject) {
    photoSelectionUtility.submitUserPhotoFromViewController(self)
}
```

After a user selects a photo from UIImagePicker, or takes a photo using the camera, this delegate method gets fired:

`func photoSelectionUtilityDidReturnImage(image: UIImage);`

which will return to you the image!

Library is supported for iOS7+

This tool was developed with the intention of helping to keep your ViewControllers light! 

