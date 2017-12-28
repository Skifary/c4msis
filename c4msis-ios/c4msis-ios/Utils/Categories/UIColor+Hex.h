//
//  UIColor+Utils.h
//
//  Created by Skifary on 28/10/2016.
//  Copyright © 2016 Skifary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

/**
 根据十六进制颜色码获取UIColor

 @param hex hex
 @return UIColor
 */
+ (UIColor *)colorWithHex:(UInt32)hex;


/**
 根据十六进制颜色码获取UIColor

 @param hex hex
 @param alpha alpha
 @return UIColor
 */
+ (UIColor *)colorWithHex:(UInt32)hex andAlpha:(CGFloat)alpha;

@end
