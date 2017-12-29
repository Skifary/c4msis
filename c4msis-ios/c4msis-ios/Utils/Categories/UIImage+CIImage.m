//
//  UIImage+CIImage.m
//  c4msis-ios
//
//  Created by Skifary on 01/12/2017.
//  Copyright © 2017 skifary. All rights reserved.
//

#import "UIImage+CIImage.h"


@implementation UIImage (CIImage)

+ (UIImage *)imageFromCIImage:(CIImage *)ciImage withSize:(CGSize)size {
    
    CGRect extent = CGRectIntegral(ciImage.extent);
    
    CGFloat extentWidth = CGRectGetWidth(extent);
    CGFloat extentHeight = CGRectGetHeight(extent);
    //设置比例
    
    CGFloat scale = MIN(size.width / extentWidth, size.height / extentHeight);
    
    // 创建bitmap
    size_t width = extentWidth * scale;
    size_t height = extentHeight * scale;
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:ciImage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
}


@end
