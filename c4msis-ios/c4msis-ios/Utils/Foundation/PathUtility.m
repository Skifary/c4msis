//
//  PathUtility.m
//  c4msis-ios
//
//  Created by Skifary on 25/11/2017.
//  Copyright © 2017 skifary. All rights reserved.
//

#import "PathUtility.h"

@implementation PathUtility

+ (NSString *)documentDirectory {
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSArray* urls = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL* url = urls.lastObject;
    return url.path;
}

@end
