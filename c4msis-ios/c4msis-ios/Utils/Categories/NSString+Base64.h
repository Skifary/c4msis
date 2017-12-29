//
//  NSString+Base64.h
//  c4msis-ios
//
//  Created by Skifary on 01/12/2017.
//  Copyright © 2017 skifary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Base64)

/**
 解码base64

 @param base64String base64 string
 @return string
 */
+ (NSString *)decodeBase64String:(NSString *)base64String;

/**
 编码base64

 @param str string
 @return base64 string
 */
+ (NSString *)encodeStringToBase64:(NSString *)str;

@end
