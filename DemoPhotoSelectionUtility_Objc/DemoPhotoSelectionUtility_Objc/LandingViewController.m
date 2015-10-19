//
//  LandingViewController.m
//  DemoPhotoSelectionUtility_Objc
//
//  Created by Matthew Sabath on 10/19/15.
//  Copyright © 2015 Matthew Sabath. All rights reserved.
//

#import "LandingViewController.h"

#import "PhotoSelectionUtility.h"

@interface LandingViewController () <PhotoSelectionUtilityDelegate>

@property (strong, nonatomic) PhotoSelectionUtility *photoSelectionUtility;
@property (strong, nonatomic) IBOutlet UIButton *addImageButton;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) UIImage *selectedImage;
@end


@implementation LandingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.photoSelectionUtility = [[PhotoSelectionUtility alloc] init];
    self.photoSelectionUtility.delegate = self;
}


#pragma mark - IBAction

- (IBAction)tappedAddImageButton:(id)sender
{
    [self.photoSelectionUtility submitUserPhotoFromViewController:self];
}

- (IBAction)tappedClearImage:(id)sender
{
    [self.imageView setImage:nil];
    [self.addImageButton setHidden:NO];
}


#pragma mark - PhotoSelectionUtilityDelegate

- (void)photoSelectionUtilityDidReturnImage:(UIImage *)image
{
    [self.imageView setImage:image];
    [self.addImageButton setHidden:YES];
    [self.addImageButton setBackgroundColor:[UIColor clearColor]];
    
    self.selectedImage = image;
}


@end
