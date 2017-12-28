//
//  ProxyRuleTableViewController.h
//  c4msis-ios
//
//  Created by Skifary on 21/11/2017.
//  Copyright © 2017 skifary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicTableViewController.h"

#import "ShadowsocksConfiguration.h"

#import "ShadowsocksConfigurationTableViewController.h"

static NSString* kPRTVCStoryBoardIndentifier = @"ProxyRuleTableViewController";

@interface ProxyRuleTableViewController : BasicTableViewController

@property (nonatomic, weak) ShadowsocksConfigurationTableViewController* prev;

@end
