//
//  UIImage+CIImage.h
//  c4msis-ios
//
//  Created by Skifary on 01/12/2017.
//  Copyright © 2017 skifary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CIImage)

/**
 CIimage转换UIImage

 @param ciImage ciimage
 @param size size
 @return uiimage
 */
+ (UIImage *)imageFromCIImage:(CIImage *)ciImage withSize:(CGSize)size;

@end
