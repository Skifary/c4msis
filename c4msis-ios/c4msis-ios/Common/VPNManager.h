//
//  VPNManager.h
//  c4msis-ios
//
//  Created by Skifary on 24/11/2017.
//  Copyright © 2017 skifary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Configuration.h"

typedef enum : NSUInteger {
    VPNStatusConnected,
    VPNStatusConnecting,
    VPNStatusDisconnect,
    VPNStatusDisconnecting,
} VPNStatus;

typedef void(^StatusUpdateHandle)(VPNStatus status);

@interface VPNManager : NSObject

@property (assign, nonatomic, readonly) VPNStatus status;

+ (instancetype)manager;

- (void)connect:(void (^)(NSError *))complete;

- (void)disconnect;

- (void)registerForStatusChange:(StatusUpdateHandle)handle;

@end
