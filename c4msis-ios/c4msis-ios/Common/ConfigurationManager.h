//
//  ConfigurationManager.h
//  c4msis-ios
//
//  Created by Skifary on 25/11/2017.
//  Copyright © 2017 skifary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Configuration.h"

@interface ConfigurationManager : NSObject

@property (nonatomic, strong, readonly, nonnull) NSMutableArray<Configuration*>* configurations;

@property (nonatomic, assign) NSInteger currentConfigurationIndex;

+ (nonnull instancetype)manager;

- (void)save;

- (void)addConfiguration:(nonnull Configuration *)configuration;

- (void)deleteConfiguration:(nonnull Configuration *)configuration;

- (void)registerForNotifacationWhenConfigurationsChanged:(nonnull void (^)(void))block;

- (nullable Configuration*)currentConfiguration;

@end
