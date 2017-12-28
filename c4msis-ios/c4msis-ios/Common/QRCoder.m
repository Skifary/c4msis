//
//  QRCoder.m
//  c4msis-ios
//
//  Created by Skifary on 01/12/2017.
//  Copyright © 2017 skifary. All rights reserved.
//

#import "QRCoder.h"

#import <CoreImage/CoreImage.h>

#import "Utility.h"

@implementation QRCoder

+ (UIImage *)qrcodeWithString:(NSString *)content withSize:(CGSize)size {
    NSData *data = [content dataUsingEncoding: NSISOLatin1StringEncoding];
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setValue:data forKey:@"inputMessage"];
    UIImage* image = [UIImage imageFromCIImage:filter.outputImage withSize:size];
    return image;
}




@end
