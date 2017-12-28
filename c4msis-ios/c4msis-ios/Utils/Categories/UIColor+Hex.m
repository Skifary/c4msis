//
//  UIColor+Utils.m
//
//  Created by Skifary on 28/10/2016.
//  Copyright © 2016 Skifary. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

+ (UIColor *)colorWithHex:(UInt32)hex {
    return [UIColor colorWithHex:hex andAlpha:1.0f];
}

+ (UIColor *)colorWithHex:(UInt32)hex andAlpha:(CGFloat)alpha {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:alpha];
}

@end
