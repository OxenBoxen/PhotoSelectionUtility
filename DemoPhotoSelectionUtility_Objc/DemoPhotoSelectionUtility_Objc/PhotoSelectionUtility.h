//
//  PhotoSelectionUtility.h
//
//  Created by Matthew Sabath
//  MIT License

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol PhotoSelectionUtilityDelegate <NSObject>

- (void)photoSelectionUtilityDidReturnImage:(UIImage *)image;

@end


@interface PhotoSelectionUtility : NSObject

@property (nonatomic, assign) NSObject <PhotoSelectionUtilityDelegate> *delegate;
- (void)submitUserPhotoFromViewController:(UIViewController *)vc;

@end

