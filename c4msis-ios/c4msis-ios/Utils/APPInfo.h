//
//  APPInfo.h
//  c4msis-ios
//
//  Created by Skifary on 29/12/2017.
//  Copyright © 2017 skifary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APPInfo : NSObject

/**
 获取 APP 名称

 @return app name
 */
+ (NSString *)name;

/**
 获取 APP 版本号

 @return app version
 */
+ (NSString *)version;

/**
 获取 APP build

 @return app build
 */
+ (NSString *)build;

@end
