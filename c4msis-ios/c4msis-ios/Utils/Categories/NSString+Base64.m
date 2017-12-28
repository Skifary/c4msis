//
//  NSString+Base64.m
//  c4msis-ios
//
//  Created by Skifary on 01/12/2017.
//  Copyright © 2017 skifary. All rights reserved.
//

#import "NSString+Base64.h"

@implementation NSString (Base64)

+ (NSString *)decodeBase64String:(NSString *)base64String {
    NSData* data = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
    NSString* decodeString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return decodeString;
}

+ (NSString *)encodeStringToBase64:(NSString *)str {
    
    NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}


@end
