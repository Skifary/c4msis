//
//  APPInfo.m
//  c4msis-ios
//
//  Created by Skifary on 29/12/2017.
//  Copyright © 2017 skifary. All rights reserved.
//

#import "APPInfo.h"

@implementation APPInfo

+ (NSString *)name {
   return [[APPInfo infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

+ (NSString *)version {
    return [[APPInfo infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)build {
    return [[APPInfo infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (NSDictionary *)infoDictionary {
    return [[NSBundle mainBundle] infoDictionary];
}

@end
