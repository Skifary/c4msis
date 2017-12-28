//
//  QRCoder.h
//  c4msis-ios
//
//  Created by Skifary on 01/12/2017.
//  Copyright © 2017 skifary. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface QRCoder : NSObject

+ (UIImage *)qrcodeWithString:(NSString *)content withSize:(CGSize)size;

@end
