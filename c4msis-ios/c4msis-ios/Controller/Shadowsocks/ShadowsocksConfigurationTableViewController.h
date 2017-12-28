//
//  ShadowsocksConfigurationTableViewController.h
//  c4msis-ios
//
//  Created by Skifary on 19/11/2017.
//  Copyright © 2017 skifary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicTableViewController.h"
#import "ShadowsocksConfiguration.h"

static NSString* kSCTVCStoryBoardIndentifier = @"ShadowsocksConfigurationTableViewController";

typedef enum : NSUInteger {
    SCTVCTypeNew,    // defualt
    SCTVCTypeModify,
} SCTVCType;

@interface ShadowsocksConfigurationTableViewController : BasicTableViewController

@property (nonatomic, strong) ShadowsocksConfiguration* configuration;

- (void)setType:(SCTVCType)type;

- (void)updateMode:(ShadowsocksProxyRule)rule;

- (void)updateMethod:(ShadowsocksMethod)method;

@end
