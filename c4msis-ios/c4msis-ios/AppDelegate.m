//
//  AppDelegate.m
//  c4msis-ios
//
//  Created by Skifary on 16/11/2017.
//  Copyright © 2017 skifary. All rights reserved.
//

#import "AppDelegate.h"

#import "ConfigurationManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    return YES;
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    // 程序退出的时候 保存
    [[ConfigurationManager manager] save];
}

@end
